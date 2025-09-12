// Header: Add ID and self links
#let compute-hash(s) = {
    s.replace(regex("\\s"), "-")
}

// Wrap show rules in a styling function so that they can be imported and used with `#show: styling`
// https://forum.typst.app/t/how-can-i-create-a-set-of-shared-set-and-show-rules-which-can-be-imported-into-a-theme/1292/3
#let styling(it) = {
    show heading: it => {
        let hash = compute-hash(it.body.text)
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
                #block(html.elem("a", attrs: (href: "#" + compute-hash(arr.at(start).body.text)))[
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

#let boj-logo = curve(
    stroke: 1.5pt + blue,
    curve.move((5pt, 2pt)),
    curve.line((1pt, 18pt)),
    curve.move((11pt, 3pt)),
    curve.line((6pt, 10pt)),
    curve.line((11pt, 17pt)),
    curve.move((13pt, 3pt)),
    curve.line((18pt, 10pt)),
    curve.line((13pt, 17pt))
)

#let baeknote-logo = square(size: 20pt, radius: 20%)[
    #align(center+horizon)[
        #scale(70%)[ #boj-logo ]
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

#let boj(problem) = [
    #link("https://www.acmicpc.net/problem/" + str(problem))[
        #html.elem("span", html.frame(boj-logo))
    ]
]

#let baeknote(problem) = [
    #let baeknote-link = "https://baeknote.bubbler.blue/problems/" + ("0" * (5 - str(problem).len()) + str(problem)).clusters().join("/") + ".html"
    #("#"+str(problem)) #link("https://www.acmicpc.net/problem/" + str(problem))[
        #html.elem("span", html.frame(scale(60%, reflow: true, boj-logo)))
    ]
    #link(baeknote-link)[
        #html.elem("span", html.frame(scale(60%, reflow: true, baeknote-logo)))
    ]
]
