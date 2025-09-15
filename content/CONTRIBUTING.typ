#import "util.typ": *

#baeknote-template(outline: false)[
    = Baeknote에 기여하기

    기여하고자 하는 문서가 이미 있다면 해당 페이지 오른쪽 상단의 수정 버튼을 눌러 기여할 수 있습니다.

    문서가 아직 없다면, 아래와 같은 과정을 거쳐 문서를 추가합니다.

    - problems 폴더 내에 문제 번호를 한 자리씩 끊어서 폴더와 파일을 만듭니다.
        - 예를 들어 29410번 문제의 위치는 `problems/2/9/4/1/0.md`입니다.
        - 4자리 번호를 갖는 문제의 경우 leading zero를 붙입니다. 1000번 문제의 위치는 `problems/0/1/0/0/0.md`입니다.
    - 생성한 문서에 다음의 내용을 복사하고 원하는 내용을 추가합니다.

    ```
    #import "util.typ": *
    
    #baeknote-template(id: 1000, title: "문제 제목")[
        == 문제 내용

        문제 내용
        
        === 입력

        입력 형식 설명 (생략 가능)
        
        === 출력

        출력 형식 설명 (생략 가능)
        
        == 문제 풀이
        
        #spoiler[
            풀이
        ]
    ]
    ```

    == 사용 가능한 기능

    - Typst의 HTML 백엔드에서 지원하는 모든 기능을 사용할 수 있습니다.
        - Markdown과 비슷한 문서 문법을 사용할 수 있습니다. [Typst - Syntax](https://typst.app/docs/reference/syntax/)를 참조해 주세요.
        - 수식을 입력할 수 있습니다. `$a+b$`를 입력하면 MathJax의 `$a+b$`와 같이 인라인 수식, `$` 안쪽에 띄어쓰기를 넣어서 `$ a+b $`와 같이 쓰면 MathJax의 `$$a+b$$`와 같이 블록 수식이 됩니다.
        - 그림 그리기와 같이 지원되지 않는 기능의 경우 [`html.frame`](https://typst.app/docs/reference/html/frame/)을 사용하면 됩니다.
        - [typst.app](https://typst.app/)에서 빈 문서를 만들어 컴파일 결과를 확인할 수 있습니다.
    - 몇 가지 편의 기능을 사용할 수 있습니다.
        - `#baeknote(1428)`을 입력하면 #baeknote(1428) 과 같이 백준 링크와 백노트 링크가 표시됩니다.
        - `#spoiler[내용]`을 입력하면 클릭으로 접었다 폈다 할 수 있는 스포일러 영역이 만들어집니다. 제목을 바꾸려면 `#spoiler(title:"다른 제목")[내용]`과 같이 사용합니다.

    == 유의점

    - 공식 풀이 또는 블로그 글을 링크할 경우, archive.org 또는 archive.md 등을 이용해 아카이브된 링크를 같이 넣어 주세요.
    - BOJ에 그대로 제출하여 AC를 받을 수 있는 코드는 넣지 말아 주세요. 대신 pseudocode를 넣는 것이 권장됩니다.
]
