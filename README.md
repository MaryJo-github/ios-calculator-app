# 🧮 계산기
> 사용자에게 연산을 입력받아 계산 결과를 보여주는 프로그램

**프로젝트 진행 기간** | 23.05.29.(월) ~ 23.06.09.(금)

## 📚 목차
- [팀원소개](#-팀원-소개)
- [타임라인](#-타임라인)
- [시각화 구조](#-시각화-구조)
- [트러블 슈팅](#-트러블-슈팅)
- [프로젝트 회고](#-프로젝트-회고)
- [참고자료](#-참고자료)


## 🧑‍💻 팀원 소개

| <img src="https://i.imgur.com/8mg0oKy.jpg" width="130" height="165"/> |
| :-: |
| [<img src="https://hackmd.io/_uploads/SJEQuLsEh.png" width="20"/> **Mary**](https://github.com/MaryJo-github) |

## ⏰ 타임라인
###### 날짜와 중요한 커밋 위주로 작성되었습니다.

- **23/05/30 (화)**
    - TDD기반 CalculatorItemQueue 기능 구현
- **23/05/31 (수)** 
    - Linked List를 이용한 Queue 구조로 변경
- **23/06/01 (목)**
    - Node, Linked List, Queue에 Generic 활용
- **23/06/02 (금)**
    - CalculatorItemQueue의 Type Parameter에 제약 추가
- **23/06/03 (토)**
    - Operator 타입 구현
- **23/06/05 (월)**
    - ExpressionParser 타입 구현
- **23/06/06 (화)**
    - Formula result 메서드 구현
    - 오류 처리 추가
    - 테스트 케이스 추가 및 ExpressionParser 리팩토링
- **23/06/09 (금)**
    - 음수기호와 뺄셈연산자를 구분하도록 Operator 수정

## 🔍 시각화 구조
**UML 클래스 다이어그램**

<img width="612" alt="스크린샷 2023-06-02 오후 2 47 43" src="https://github.com/MaryJo-github/ios-calculator-app/assets/42026766/b0b41931-f1a2-473e-b2aa-7e332f495bfb">

## 🔨 트러블 슈팅 

### 1️⃣ **다양한 큐 구현 방법**
 사용자가 입력한 연산을 저장하기 위해 큐를 만들고자하였고, 다양한 구현방법 중 어떤 것을 활용할지 고민하였습니다. 먼저 각 방법을 직접 구현해보고 장단점을 비교해보았습니다.

🔑 **첫번째 방안 - Array (dequeue: removeFirst())**
<details>
<summary>코드 및 장단점</summary>
<div markdown="1">
    
```swift
var itemQueue: [String] = []

mutating func enqueue(_ element: String) {
    itemQueue.append(element)
}

mutating func dequeue() -> String? {
    return itemQueue.isEmpty ? nil : itemQueue.removeFirst()
}
```

- **장점**
  - 가장 간결하게 구현할 수 있습니다.

- **단점**
  - dequeue 호출시 뒷 쪽의 값들을 앞으로 당겨오는 작업이 필요하기때문에 시간 복잡도는 O(n)입니다.
</div>
</details>
    
<br>
    
🔑 **두번째 방안 - Array (dequeue: Pointer)**
<details>
<summary>코드 및 장단점</summary>
<div markdown="1">

```swift
var itemQueue: [String?] = []
private var head = 0
private var size: Int {
    return itemQueue.count
}

mutating func enqueue(_ element: String) {
    itemQueue.append(element)
}

mutating func dequeue() -> String? {
    guard head <= size,
          let element = itemQueue[head] else { return nil }
    itemQueue[head] = nil
    head += 1
    return element
}
```
                      
- **장점**
  - dequeue 호출시 배열은 그대로 두고 head라는 포인터만 변경해주기 때문에 시간복잡도가 낮습니다.

- **단점**
  - dequeue된 요소들이 배열에 nil로 남기때문에 메모리가 낭비됩니다.
                      
</div>
</details>
        
<br>
    
🔑 **세번째 방안 - Double Stack Queue**
<details>
<summary>코드 및 장단점</summary>
<div markdown="1">
    
```swift
var leftStack: [String] = []
var rightStack: [String] = []

mutating func enqueue(_ element: String) {
    itemQueue.append(element)
}

mutating func dequeue() -> String? {
    if leftStack.isEmpty {
        leftStack = rightStack.reversed()
        rightStack = []
    }
    return leftStack.popLast()
}
```
- **장점**
  - reversed 메소드를 이용하여 큐를 뒤집은 프로퍼티를 생성해줌으로써 dequeue 호출 시 시간복잡도는 O(1) 입니다. (LeftStack이 비어있지 않을 때에만 적용됩니다.)

- **단점**
  - LeftStack이 비어있을 때에는 reversed 메소드를 호출하여 leftStack에 넣는 작업을 진행합니다. 이 때의 시간복잡도는 O(n)이 됩니다.

</div>
</details>
        
<br>
    
🔑 **네번째 방안 - Linked List**
<details>
<summary>코드 및 장단점</summary>
<div markdown="1">    

```swift
private var front: Node?
private var tail: Node?
private(set) var size: Int = 0
var isEmpty: Bool { size == 0 }

mutating func enqueue(_ element: String) {
    let newNode = Node(element: element)

    if isEmpty {
        front = newNode
        tail = front
    } else {
        tail?.next = newNode
        tail = newNode
    }
    size += 1
}

mutating func dequeue() -> String? {
    guard let firstElement = front?.element else { return nil }

    front = front?.next
    size -= 1

    if isEmpty {
        front = nil
        tail = nil
    }

    return firstElement
}
```
- **장점**
  - dequeue 호출시 노드의 연결만 끊으면 되기 때문에 시간복잡도는 항상 O(1) 입니다.

- **단점**
  - 요소에 바로 접근하는 것이 불가능하고 연결되어 있는 링크를 따라가야만하여 접근속도가 느립니다.

</div>
</details>
        
<br>

**최종 선택**
    
→ 중간에 있는 node를 직접적으로 접근할 필요가 없는 현재 프로젝트에서는 탐색속도를 고려할 필요가 없고, 시간복잡도가 항상 O(1)로 낮은 Linked List 방법이 가장 적절하다고 판단하였습니다.


### 2️⃣ **제너릭 타입 활용**
🔒 **문제점**
    
 숫자를 담는 숫자큐와 연산을 담는 연산큐를 만들 때, 숫자(Double)와 연산(Operator)의 타입이 다르기 때문에 각각의 큐를 만들어주면 동일한 코드가 중복되는 문제점이 있었습니다.
``` swift
struct CalculatorDoubleQueue { ... }
struct CalculatorOperatorQueue { ... }
```

🔑 **해결 방법**
    
 `CalculatorItemQueue`에 제너릭을 이용하여 큐 아이템의 타입을 자유롭게 받을 수 있도록 변경하였습니다. 추가로, 아무 타입이나 들어오지 못하도록 빈 프로토콜인 `CalculateItem`을 생성하여 `Type Parameter`에 제약을 추가하였습니다.
``` swift
struct CalculatorItemQueue<Item: CalculateItem> { ... }
```
    
### 3️⃣ **음수를 나타내는 기호와 뺄셈 연산자 구분**
🔒 **문제점**
    
 계산기에는 `ChangeSignButton`이 있어 해당 버튼을 통해 숫자를 음수로 변경해줄 수 있습니다. 그래서 만약 뺄셈연산자를 누르고 2와 `ChangeSignButton`을 누르면 `1--2` 같은 수식이 만들어지게됩니다. 이 수식을 정상적으로 계산하려면 뺄셈연산자와 음수를 나타내는 기호를 구분해야합니다.
처음에는 수식에 `--`가 들어오면 `+`로 변경하고, `+-`가 들어오면 `-`로 변경해주는 로직으로 구현하였는데, 이렇게 하면 `*-`, `/-` 처리를 따로 해주어야하고, 코드의 길이도 길어져서 가독성이 좋지 않았습니다.

🔑 **해결 방법**
    
 기존에 구현되어있던 storyboard에서 뺄셈 연산자 버튼의 타이틀과 음수를 나타내는 기호 `-`를 비교해보았습니다.
``` swift
let `operator` = "−"
let negativeSign = "-"

print(`operator`.unicodeScalars.first!.value)
print(negativeSign.unicodeScalars.first!.value)
    
// 8722
// 45
```
두 개의 unicode를 확인해보니 각각 `8722`와 `45`로 값이 다르게 나왔고, 이로써 서로 다른 기호라는 것을 알아차릴 수 있었습니다. 따라서 `Operator`에서 원시값을 연산자 버튼의 타이틀로 변경해줌으로써 해당 문제를 해결할 수 있었습니다.
    
## 👥 프로젝트 회고
### 잘한 부분
- 그라운드 룰로 정한 시간대를 잘 지킨 점
- 제너릭과 같이 기존에는 알지못했던 문법들을 적용하려고 노력한 점

### 부족한 부분 
- 요구사항을 꼼꼼하게 확인하지 못해서 수정작업을 거쳤던 점
    
## 📑 참고자료
[Generic Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/#Generic-Types) 
[Type Constraints](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/#Type-Constraints)
