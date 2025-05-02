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
            nbs = nbs .. string.format("<a class=\"active\"><span>%s</span></a>", item.name)
        else
            nbs = nbs .. string.format("<a href=\"%s\"><span>%s</span></a>", to_rel_url(item.url, depth), item.name)
        end
    end

    return nbs .. "</span>"
end

function generate_socials()
    local soc = ""

    for _, i in ipairs(config.navbar.socials) do
        soc = soc .. string.format("<a href=\"%s\" aria-label=\"%s\"><span class=\"fa-brands fa-%s\">%s</span></a>", i.url, i.icon, i.icon, i.icon)
    end

    return soc
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
	local title = "funn's home"
	if options.title ~= nil then
		title = title .. " — " .. options.title
	end

    local navbar_items = ""
	for _, i in ipairs(config.navbar.items) do
        navbar_items = navbar_items .. generate_navside(md_path, depth, i)
    end

    local social_items = generate_socials()

    if options.is_blog_list then
        local posts = search_in(path_join(project_base, "blogs"), path_parent(out_path), depth)
        table.sort(posts, function(a, b)
            return a.options.date > b.options.date
        end)

        gen_posts = {}
        post_idx_by_cat = {}

        body = body .. [[<style>@import url("index.css");</style><div id="posts_by_date"><h2>List of blog posts by date</h2>]]
        for i, p in ipairs(posts) do
            for _, t in ipairs(p.options.tags) do
                if post_idx_by_cat[t] == nil then
                    post_idx_by_cat[t] = {}
                end

                table.insert(post_idx_by_cat[t], i)
            end

            local date = date_to_string(p.options.date)

            gen_posts[i] = string.format("<div class=\"card\"><div class=\"top\"><a href=\"%s\" class=\"title\">%s</a><span class=\"date\"><i class=\"fa-solid fa-calendar-days\"></i> %s</span></div><span class=\"tags\"><i class=\"fa-solid fa-tags\"></i> %s</span></div>", path_relative_to(p.out_path, path_parent(out_path)), sanitize(p.options.title), date, gen_tags_string(p.options.tags))
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
            body = body .. '<h3 id="tag_' .. sanitize(t.tag) .. '"><i class="fa-solid fa-tag"></i> ' .. sanitize(t.tag) .. "</h3>"
            for _, v in ipairs(t.posts) do
                body = body .. gen_posts[v]
            end
        end
    end

    if md_path:find("/blogs/") then
        local date = date_to_string(options.date)

        body = string.format([[
<style>@import url("style.css");</style><div class="blog_header"><h1>%s</h1><div><div><i class="fa-solid fa-tag"></i> %s</div><div><i class="fa-solid fa-calendar-days"></i> %s</div></div></div>
]], sanitize(options.title), gen_tags_string(options.tags), date) .. body
    end

	return string.format([[
<!DOCTYPE HTML>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>
        <link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Fira+Sans:ital,wght@0,400;0,500;0,700;1,400;1,700&display=swap">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fira+Sans:ital,wght@0,400;0,500;0,700;1,400;1,700&display=swap">
        <script src="/theme.js"></script>
        <link rel="preload" as="style" href="https://cdn.jsdelivr.net/npm/katex@0.16.10/dist/katex.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.10/dist/katex.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="/style.css">
        <script defer src="/script.js"></script>
        <script defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/js/fontawesome.min.js" crossorigin="anonymous"></script>
        <script defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/js/solid.min.js" crossorigin="anonymous"></script>
        <script defer src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/js/brands.min.js" crossorigin="anonymous"></script>
        <title>%s</title>
    </head>
    <body>
        <script>0</script>
        <nav>
            <div id="navbg"></div>
            <a href="/"><img
                class="logo"
                srcset="
                    /pfp_1x.jpg,
                    /pfp_2x.jpg 2x,
                    /pfp_3x.jpg 3x,
                    /pfp_4x.jpg 4x,
                "
                src="/pfp_1x.jpg"
                alt="Logo"
                width="40"
                height="40"
            ></a>
            <div id="navham">
                <button id="theme_tog_mob" aria-label="Toggle light/dark theme"><span class="fa-solid fa-fw fa-lg">Toggle light/dark theme</span></button>
                <button id="hamburger" aria-label="Menu"><span class="fa-solid fa-bars fa-lg">Menu</span></button>
            </div>
            <div id="navinner">
                %s
                <span class="social">%s</span>
                <button id="theme_tog" aria-label="Toggle light/dark theme"><span class="fa-solid fa-fw fa-lg">Toggle light/dark theme</span></button>
            </div>
        </nav>
        <div id="page_content">%s</div>
    </body>
</html>
]], sanitize(title), navbar_items, social_items, body)
end
