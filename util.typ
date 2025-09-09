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
        set text(14pt)
        html.elem("span", attrs: (role: "math"), html.frame(it))
    }
    show math.equation.where(block: true): it => {
        set text(14pt)
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
            let list-items = start-idxs.windows(2).map(((start, end)) => {
                html.elem("a", attrs: (href: "#" + compute-hash(arr.at(start).body.text)))[
                    #arr.at(start).body
                ] + if start + 1 < end { gen-outline(arr.slice(start + 1, end)) }
            })
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
