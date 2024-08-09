-- This is just https://github.com/funnsam/mw/blob/main/postprocess.lua, with some changes

local function to_rel_url(url, depth)
	if string.match(url, "^.+://.*") or string.match(url, "^%./.*") or string.match(url, "^/.*") then
		return url
	else
		local url = string.rep("../", depth) .. url
		if #url ~= 0 then
			return url
		else
			return "./"
		end
	end
end

function generate_navside(md_path, depth, navside)
	local nbs = "<span>"
	for item = 1, #navside do
		local item = navside[item]

        if item.md ~= nil and "pages/" .. item.md == path_relative(md_path) then
            nbs = nbs .. string.format("<a class=\"active\">%s</a>", item.name)
        else
            nbs = nbs .. string.format("<a href=\"%s\">%s</a>", to_rel_url(item.url, depth), item.name)
        end
    end

    return nbs .. "</span>"
end

function generate_final_html(md_path, out_path, depth, body, options)
	local title_html = ""
	if options.title ~= nil then
		title_html = string.format("%s", options.title)
	end

    local navbar_items = ""
	for i = 1, #navbar.items do
        navbar_items = navbar_items .. generate_navside(md_path, depth, navbar.items[i])
    end

    if options.is_blog then
    end

	return string.format([[
<!DOCTYPE HTML><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.10/dist/katex.min.css" crossorigin="anonymous"><link rel="stylesheet" href="%sstyle.css"><script defer src="%sscript.js"></script><title>%s</title></head><body><nav><div id="navham"><a href="/"><img class="logo" src="%s" alt="Logo"></a><button id="hamburger">More</button></div><div id="navinner"><a href="/"><img class="logo" src="%s" alt="Logo"></a>%s</div></nav><div id="page_content">%s</div></body></html>
]], string.rep("../", depth), string.rep("../", depth), title_html, navbar.logo, navbar.logo, navbar_items, body)
end
