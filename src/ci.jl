"""
    write_thanks_page()

Thanks page for when people sign up for email updates.
"""
function write_thanks_page()
    text = """
        <!DOCTYPE html>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="en-US" xml:lang="en-US">
        <body>
            <div style="margin-top: 40px; font-size: 40px; text-align: center;">
                <br>
                <br>
                <br>
                <div style="font-weight: bold;">
                    Thank you
                </div>
                <br>
                <div>
                    You successfully signed up for email updates.
                </div>
                <br>
                <br>
                <div style="margin-bottom: 300px; font-size: 24px">
                    <a href="/">Click here</a> to go back to the homepage.
                </div>
            </div>
        </body>
        """
    path = joinpath(BUILD_DIR, "thanks.html")
    write(path, text)
    return path
end

function build_all(; project="default", extra_head="", fail_on_error=false)
    mkpath(BUILD_DIR)
    filename = "favicon.png"
    from_path = joinpath("pandoc", filename)
    if isfile(from_path)
        cp(from_path, joinpath(BUILD_DIR, filename); force=true)
    end
    build_sitemap = true
    html(; project, extra_head, fail_on_error, build_sitemap)
    write_extra_html_files(project)
    pdf(; project=project)
    # docx(; project)
end

function install_fonts()
    @info "installing font[NotoSerifCJKsc]..."
    fonts_dir = joinpath(homedir(), ".fonts")
    mkpath(fonts_dir)
    run(`wget -q -O tmp.zip https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKsc-hinted.zip`)
    run(`unzip tmp.zip -d $(joinpath(fonts_dir, "NotoSerifCJKsc"))`)
    run(`rm tmp.zip`)
    run(`fc-cache --verbose $fonts_dir`)
end

"""
    build()

This method is called during CI.
"""
function build()
    println("Building JDS")
    install_fonts()
    write_thanks_page()
    fail_on_error = true
    gen(; fail_on_error)
    build_all(; fail_on_error)
end
