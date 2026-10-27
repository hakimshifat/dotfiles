--- @since 26.9.1

--- Create an archive out of the current selection (or the hovered entry).
---
--- Two bindings in `keymap.toml`:
---   c    -> plugin compress
---   C    -> plugin compress -- password
---
--- Extra arguments, all optional:
---   --password    encrypt with AES-256 (handled by 7z, so every format works)
---   --level=N     compression level 0-9 (zip and 7z only, default below)
---   --force       overwrite the archive without asking

local TITLE = "Compress"

-- Level used when `--level` isn't given. `tar.*` ignores this and lets the
-- underlying compressor pick its own default.
local DEFAULT_LEVEL = { zip = 6, ["7z"] = 5 }

-- Recognised suffixes, longest first so `.tar.gz` wins over `.gz`.
local SUFFIXES = {
	{ ".tar.gz", "tar.gz" }, { ".tar.zst", "tar.zst" },
	{ ".tar.bz2", "tar.bz2" }, { ".tar.xz", "tar.xz" },
	{ ".tgz", "tar.gz" }, { ".tbz2", "tar.bz2" }, { ".tbz", "tar.bz2" },
	{ ".txz", "tar.xz" }, { ".tzst", "tar.zst" },
	{ ".tar", "tar" }, { ".zip", "zip" }, { ".7z", "7z" },
}

-- A "need" listed here is satisfied by any one of its candidates; any other
-- need has to exist under that exact name.
local ALIASES = { seven = { "7z", "7za", "7zz" } }

local NEEDS = {
	zip = { "zip" },
	["7z"] = { "seven" },
	tar = { "tar" },
	["tar.gz"] = { "tar" },
	["tar.bz2"] = { "tar", "bzip2" },
	["tar.xz"] = { "tar", "xz" },
	["tar.zst"] = { "tar", "zstd" },
}

local TAR_FLAG = {
	["tar.gz"] = { "-z" },
	["tar.bz2"] = { "-j" },
	["tar.xz"] = { "-J" },
	["tar.zst"] = { "--zstd" },
}

local PROBE = { "zip", "7z", "7za", "7zz", "tar", "bzip2", "xz", "zstd" }

local function say(content, level)
	ya.notify { title = TITLE, content = content, level = level, timeout = 6 }
end

-- `ya.which` is a key prompt, not a PATH lookup, so ask the shell once for
-- every candidate instead of spawning a process per tool.
local function available_tools()
	local script = 'for b in ' .. table.concat(PROBE, " ") .. '; do command -v "$b" 2>/dev/null; done'
	local out = Command("sh"):arg("-c"):arg(script):output()

	local found = {}
	if out then
		for line in out.stdout:gmatch("[^\n]+") do
			found[line:match("([^/]+)$") or line] = true
		end
	end
	return found
end

local function resolve(found, need)
	local alts = ALIASES[need]
	if alts then
		for _, name in ipairs(alts) do
			if found[name] then
				return name
			end
		end
		return nil
	end
	return found[need] and need or nil
end

local function missing_tools(fmt, found)
	local absent = {}
	for _, need in ipairs(NEEDS[fmt] or {}) do
		if not resolve(found, need) then
			absent[#absent + 1] = ALIASES[need] and table.concat(ALIASES[need], " / ") or need
		end
	end
	return absent
end

-- Snapshot the selection on the main thread. `File` userdata can't cross into
-- the async context, so flatten everything to plain strings and numbers.
local snapshot = ya.sync(function()
	local cwd = tostring(cx.active.current.cwd)

	local picked = {}
	local selected = cx.active.selected
	if #selected > 0 then
		for _, file in pairs(selected) do
			picked[#picked + 1] = file
		end
	elseif cx.active.current.hovered then
		picked[1] = cx.active.current.hovered
	end

	local items = {}
	local prefix = cwd
	if prefix:sub(-1) ~= "/" then
		prefix = prefix .. "/"
	end

	for i, file in ipairs(picked) do
		local path = tostring(file.url)
		-- Store paths relative to the CWD so the archive keeps clean entries,
		-- but fall back to the absolute path if the file lives elsewhere.
		local rel = path
		if path:sub(1, #prefix) == prefix then
			rel = path:sub(#prefix + 1)
		end

		items[i] = { rel = rel, name = file.name, is_dir = (file.cha and file.cha.is_dir) or false }
	end

	table.sort(items, function(a, b) return a.rel < b.rel end)
	return cwd, items
end)

local function suggest(items, cwd)
	local base

	if #items == 1 then
		base = items[1].name
		if not items[1].is_dir then
			-- Don't turn `photos.zip` into `photos.zip.zip`.
			local lower = base:lower()
			for _, s in ipairs(SUFFIXES) do
				if #lower > #s[1] and lower:sub(-#s[1]) == s[1] then
					return base
				end
			end
			base = base:match("^(.+)%.[^.]+$") or base
		end
	else
		base = cwd:match("([^/]+)$") or ""
		if base == "" then
			base = "archive"
		end
	end

	return base .. ".zip"
end

-- Returns the archive name and the format it implies.
local function detect(name)
	local lower = name:lower()
	for _, s in ipairs(SUFFIXES) do
		if #lower > #s[1] and lower:sub(-#s[1]) == s[1] then
			return name, s[2]
		end
	end
	return name .. ".zip", "zip"
end

local function level_of(fmt, raw)
	local level = tonumber(raw)
	if not level then
		return DEFAULT_LEVEL[fmt]
	end

	level = math.floor(level)
	if level < 0 then
		level = 0
	elseif level > 9 then
		level = 9
	end
	return level
end

local function build(fmt, out, items, pwd, level, seven)
	local names = {}
	for _, item in ipairs(items) do
		names[#names + 1] = item.rel
	end

	if pwd then
		-- Route every encrypted archive through 7z: Info-ZIP's -P would give
		-- the much weaker ZipCrypto instead of AES-256.
		return Command(seven):arg("a"):arg("-t" .. fmt):arg("-mx=" .. math.max(1, level))
			:arg("-p" .. pwd):arg(out):arg("--"):arg(names)
	end

	if fmt == "zip" then
		return Command("zip"):arg("-" .. level):arg("-r"):arg("-q"):arg(out):arg("--"):arg(names)
	end

	if fmt == "7z" then
		return Command(seven):arg("a"):arg("-mx=" .. level):arg(out):arg("--"):arg(names)
	end

	return Command("tar"):arg("-c"):arg(TAR_FLAG[fmt] or {}):arg("-f"):arg(out):arg("--"):arg(names)
end

return {
	entry = function(_, job)
		local args = job.args or {}
		-- `--password` arrives as a named arg, but `plugin compress -- password`
		-- arrives as a positional one, so accept both spellings.
		local want_pwd = args.password == true or args[1] == "password"

		local cwd, items = snapshot()
		if #items == 0 then
			return say("Nothing to compress", "warn")
		end

		local found = available_tools()
		local seven = resolve(found, "seven")

		local name, event = ya.input {
			pos = { "top-center", y = 3, w = 50 },
			title = ("Archive name (%d item%s)"):format(#items, #items == 1 and "" or "s"),
			value = suggest(items, cwd),
		}
		if event ~= 1 then
			return
		end

		name = (name or ""):match("^%s*(.-)%s*$")
		if name == "" then
			return
		end
		if name:find("/", 1, true) or name:find("\\", 1, true) then
			return say("An archive name can't contain a path separator", "error")
		end

		local fmt
		name, fmt = detect(name)

		local absent = missing_tools(fmt, found)
		if #absent > 0 then
			return say(("Can't make a `%s` archive, missing: %s"):format(fmt, table.concat(absent, ", ")), "error")
		end

		local level = level_of(fmt, args.level)
		if not level then
			level = 5
		end

		-- Level 0 means "store, don't compress", which the zip and 7z
		-- writers only accept for their own format.
		if fmt ~= "zip" and fmt ~= "7z" and level == 0 then
			level = 1
		end

		local pwd
		if want_pwd then
			if not seven then
				return say("Password-protected archives need `7z` (or `7za` / `7zz`)", "error")
			end

			local value, ev = ya.input {
				pos = { "top-center", y = 3, w = 50 },
				title = ("Password for %s (AES-256):"):format(name),
				obscure = true,
			}
			if ev ~= 1 then
				return
			end

			pwd = value or ""
			if pwd == "" then
				return say("Empty password, nothing was archived", "warn")
			end
		end

		if not args.force and fs.cha(Url(cwd):join(name)) then
			local overwrite = ya.confirm {
				pos = { "center", w = 50, h = 8 },
				title = TITLE,
				body = name .. " already exists.\nOverwrite it?",
			}
			if not overwrite then
				return
			end
		end

		local status, err = build(fmt, name, items, pwd, level, seven):cwd(cwd):status()
		if not status then
			return say(tostring(err), "error")
		elseif not status.success then
			return say(("`%s` failed with exit code %s"):format(name, tostring(status.code)), "error")
		end

		ya.notify { title = TITLE, content = "Created " .. name, level = "info", timeout = 4 }
	end,
}