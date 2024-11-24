-- This is just https://github.com/funnsam/mw/blob/main/postprocess.lua, with some changes

local function to_rel_url(url, depth)
	if url:match("^.+://.*") or url:match("^%./.*") or url:match("^/.*") then
		return url
	else
		local url = ("../"):rep(depth) .. url
		if #url ~= 0 then
			return url
		else
			return "./"
		end
	end
end

function generate_navside(md_path, depth, navside)
	local nbs = "<span>"
	for _, item in ipairs(navside) do
        if item.md ~= nil and item.md == path_relative_to(md_path, pages_base) then
            nbs = nbs .. string.format("<a class=\"active\">%s</a>", item.name)
        else
            nbs = nbs .. string.format("<a href=\"%s\">%s</a>", to_rel_url(item.url, depth), item.name)
        end
    end

    return nbs .. "</span>"
end

function sanitize(s)
    return s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;")
end

function date_to_string(date)
    local y = date // 10000
    local m = date // 100 % 100
    local d = date % 100

    return y .. "/" .. m .. "/" .. d
end

function gen_tags_string(tags)
    local s = ""

    for i, t in ipairs(tags) do
        if i ~= 1 then
            s = s .. ", "
        end

        s = s .. '<a class="tag" href="/blog#tag_' .. sanitize(t) .. '">' .. sanitize(t) .. "</a>"
    end

    return s
end

function generate_final_html(md_path, out_path, depth, body, options)
	local title = "funn's homie"
	if options.title ~= nil then
		title = title .. " — " .. options.title
	end

    local navbar_items = ""
	for _, i in ipairs(config.navbar.items) do
        navbar_items = navbar_items .. generate_navside(md_path, depth, i)
    end

    if options.is_blog_list then
        local posts = search_in(path_join(project_base, "blogs"), path_parent(out_path), depth)
        table.sort(posts, function(a, b)
            return a.options.date > b.options.date
        end)

        gen_posts = {}
        post_idx_by_cat = {}

        body = body .. [[<style>@import url("index.css");</style><div id=\"posts_by_date\"><h2>List of blog posts by date</h2>]]
        for i, p in ipairs(posts) do
            for _, t in ipairs(p.options.tags) do
                if post_idx_by_cat[t] == nil then
                    post_idx_by_cat[t] = {}
                end

                table.insert(post_idx_by_cat[t], i)
            end

            local date = date_to_string(p.options.date)

            gen_posts[i] = string.format("<div class=\"post\"><div class=\"top\"><a href=\"%s\" class=\"title\">%s</a><span class=\"date\">📅 %s</span></div><span class=\"tags\">🏷️ %s</span></div>", path_relative_to(p.out_path, path_parent(out_path)), sanitize(p.options.title), date, gen_tags_string(p.options.tags))
            body = body .. gen_posts[i]
        end

        body = body .. "</div>"
        body = body .. "<div id=\"posts_by_tags\"><h2>List of blog posts by tag</h2>"

        local sorted = {}
        for k, v in pairs(post_idx_by_cat) do
            table.insert(sorted, { tag = k, posts = v })
        end
        table.sort(sorted, function(a, b)
            return a.tag < b.tag
        end)

        for _, t in ipairs(sorted) do
            body = body .. '<h3 id="tag_' .. sanitize(t.tag) .. '">🏷️ ' .. sanitize(t.tag) .. "</h3>"
            for _, v in ipairs(t.posts) do
                body = body .. gen_posts[v]
            end
        end
    end

    if md_path:find("/blogs/") then
        local date = date_to_string(options.date)

        body = string.format([[
<style>@import url("style.css");</style><div class="blog_header"><h1>%s</h1><div><div><span>🏷️</span><span>%s</span></div><div><span>📅</span><span>%s</span></div></div></div>
]], sanitize(options.title), gen_tags_string(options.tags), date) .. body
    end

	return string.format([[
<!DOCTYPE HTML><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.10/dist/katex.min.css" crossorigin="anonymous"><link rel="stylesheet" href="%sstyle.css"><script defer src="%sscript.js"></script><title>%s</title></head><body><script>0</script><nav><div id="navham"><a href="/"><img class="logo" src="%s" alt="Logo"></a><button id="hamburger">More</button></div><div id="navinner"><a href="/"><img class="logo" src="%s" alt="Logo"></a>%s</div></nav><div id="page_content">%s</div></body></html>
]], ("../"):rep(depth), ("../"):rep(depth), sanitize(title), config.navbar.logo, config.navbar.logo, navbar_items, body)
end
