// Header: Add ID and self links
#let compute-hash(s) = {
    s.replace(regex("\\s"), "-")
}

// Extract plain text from any element
// https://sitandr.github.io/typst-examples-book/book/typstonomicon/extract_plain_text.html
#let plain-text(it) = {
    return if type(it) == str {
        it
    } else if it == [ ] {
        " "
    } else if it.has("children") {
        it.children.map(plain-text).join()
    } else if it.has("body") {
        plain-text(it.body)
    } else if it.has("text") {
        if type(it.text) == str {
            it.text
        } else {
            plain-text(it.text)
        }
    } else {
        ""
    }
}

// Wrap show rules in a styling function so that they can be imported and used with `#show: styling`
// https://forum.typst.app/t/how-can-i-create-a-set-of-shared-set-and-show-rules-which-can-be-imported-into-a-theme/1292/3
#let styling(it) = {
    set list(tight: false)

    show heading: it => {
        let hash = compute-hash(plain-text(it))
        html.elem("h" + str(it.depth), attrs: (id: hash))[
            //#html.elem("a", attrs: (class: "header", href: "#" + hash))[
                #it.body
            //]
        ]
    }

    // Math: At the moment, HTML backend cannot emit math equations directly.
    // Workaround: emit them as SVG entities. https://github.com/typst/typst/issues/721#issuecomment-2817289426
    show math.equation.where(block: false): it => {
        set text(13pt)
        html.elem("span", attrs: (role: "math"), html.frame(it))
    }
    show math.equation.where(block: true): it => {
        set text(13pt)
        html.elem("figure", attrs: (role: "math"), html.frame(it))
    }
    it
}

// Outline generation: Extract headers and form lists out of them
#let gen-outline() = {
    context {
        let headers = query(selector(heading).after(heading.where(depth: 1), inclusive: false))
        let gen-outline(arr) = {
            let start-depth = arr.at(0).depth
            let start-idxs = arr.enumerate().filter(((idx, it)) => it.depth == start-depth).map(((idx, it)) => idx) + (arr.len(),)
            let list-items = start-idxs.windows(2).map(((start, end)) => [
                #block(html.elem("a", attrs: (href: "#" + compute-hash(plain-text(arr.at(start)))))[
                    #arr.at(start).body
                ])
                #if start + 1 < end { gen-outline(arr.slice(start + 1, end)) }
            ])
            list(..list-items)
        }
        gen-outline(headers)
    }
}

// Helper function to wrap contents in spoiler section
#let spoiler(body, title:"스포일러") = {
    html.elem("details", [
        #html.elem("summary", title)

        #body
    ])
}

// Helper function to attach title (tooltip on hover) on links
#let alink(link, caption, body) = [
    #html.elem("a", attrs: (href: link, title: caption), body)
]

#let boj-logo(thickness) = curve(
    stroke: blue + thickness,
    curve.move((5pt, 0pt)),
    curve.line((1pt, 16pt)),
    curve.move((11pt, 1pt)),
    curve.line((6pt, 8pt)),
    curve.line((11pt, 15pt)),
    curve.move((13pt, 1pt)),
    curve.line((18pt, 8pt)),
    curve.line((13pt, 15pt))
)

#let boj-logo-basic = boj-logo(1.5pt)

#let baeknote-logo = square(size: 20pt, radius: 20%)[
    #align(center+horizon)[
        #move(dy: 1.5pt, scale(70%, boj-logo(2pt)))
    ]
    #place(top+center,
        curve(
            curve.move((0pt, -8pt)),
            curve.quad((-3pt, -4.5pt), (0pt, -1pt)),
            curve.move((3pt, -8pt)),
            curve.quad((0pt, -4.5pt), (3pt, -1pt)),
            curve.move((6pt, -8pt)),
            curve.quad((3pt, -4.5pt), (6pt, -1pt)),
            curve.move((9pt, -8pt)),
            curve.quad((6pt, -4.5pt), (9pt, -1pt)),
        )
    )
]

#let boj(problem, title) = [
    BOJ #problem #title
    #alink("https://www.acmicpc.net/problem/" + str(problem), "BOJ " + str(problem))[
        #html.elem("span", attrs:(style: "vertical-align: middle;"), html.frame(boj-logo-basic))
    ]
]

#let baeknote(problem) = [
    #let baeknote-link = "https://baeknote.bubbler.blue/problems/" + ("0" * (5 - str(problem).len()) + str(problem)).clusters().join("/") + ".html"
    #("#"+str(problem)) #alink("https://www.acmicpc.net/problem/" + str(problem), "BOJ " + str(problem))[
        #html.elem("span", attrs:(style: "vertical-align: middle;"), html.frame(scale(67.5%, reflow: true, boj-logo-basic)))
    ]
    #alink(baeknote-link, "Baeknote " + str(problem))[
        #html.elem("span", attrs:(style: "vertical-align: middle;"), html.frame(scale(54%, reflow: true, baeknote-logo)))
    ]
]

#let baeknote-template(id: none, title: none, outline: true, body) = [
    #show: styling

    #if id != none [
        = #boj(id, title)
    ]

    #if outline [ #gen-outline() ]

    #body
]
