/*
 The MIT License (MIT)

 Copyright © «2023» «V228a»

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
import SwiftUI



struct ContentView: View {
    @State private var activateRootLink = false
    @State var num = [1,2,3,4]
    
    func generateRandomNumbers() -> [Int] {
          var numbers = [Int]()
          while numbers.count < 4 {
            let number = Int.random(in: 1...9)
            if !numbers.contains(number) {
              numbers.append(number)
            }
          }
          return numbers
        }
    
    
    var body: some View {
        NavigationView {
                    VStack {
                        NavigationLink(destination: SecondView(numbers: num)) {
                            Text("Играть")
                        }.padding()
                        Spacer()
                        NavigationLink(destination: HoToPlayView()) {
                            Text("Как играть")
                        }.padding()
                        
                        HStack{
                        Text("Copyright © «2023»")
                            Button(action: {
                               if let url = URL(string: "https://github.com/v228a/super_mind_siemens_sl45_ios") {
                                  UIApplication.shared.open(url)
                               }
                            }) {
                               Text("«V228a»")
                            }
                        }
                    }
                    .navigationTitle("Super Mind")
                    .onDisappear {
                        self.num = []
                    }
                    .onAppear {
                        self.num = generateRandomNumbers()
                    }
        }
    }
}





struct SecondView: View {
    @State var numbers: [Int]
    //@Binding var showGame: Bool
    
    //Тут  храняться все числа которые вводит игрок
    //Начинаються они с -1 одного так как надо понимать ввел ли игрок число
    //0 не получиться использовать так как он используються в игре :)
    @Environment(\.presentationMode) var presentationMode
    @State var InputNumber: [Int] = [-1,-1,-1,-1]
    @State var LastA = -1 //Последния вводимая A
    @State var LastB = -1 // Последнея вводимая B
    @State var EnteredNumbers: [Int] = []//Черный список цифр чтобы они не повотялись при вводе
    @State var LastInput: [Int] = [-1,-1,-1,-1]//Последний ввод чисел
    @State var Attempt: Int = 0//Попытки
    @State var showAlert: Bool = false//Показывать ли диалог
    @State var TextAlertDialog: String = ""//Текст диалога победа проигрыша
    @State var MesseageAlertDialog: String = ""//Сообщения диалога победа проигрыша
    /*
     .alert(isPresented: $showAlert) {
         Alert(
             title: Text(loss == false ? "Победа":"Проигрыш"),
             message: Text("\(loss == false ? "Поздравляем с победой!":"Не вышло :(") \n Правильное число \(numbers[0])\(numbers[1])\(numbers[2])\(numbers[3])"),
             dismissButton: .default("OK", action: {back()}))
     }
     */
    
    
    @State var History: [[Int]] = [[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],[-1,-1,-1],]//История ввода данных в формате [[1234,2,1]] число, A,B
    func back(){
        
        self.presentationMode.wrappedValue.dismiss()

    }
    
    @State var A: Int = 0
    @State var B: Int = 0
    func Game(){
        
        for i in 0..<numbers.count { //проходим по массиву 1
            for j in 0..<InputNumber.count { //проходим по массиву 2
                if numbers[i] == InputNumber[j] { //если числа совпадают, то
                    if i == j { //по индексу
                        A += 1
                    }else { //по значению
                        B += 1
                    }
                }
            }
        }
        
       
        if Attempt == 7{
            TextAlertDialog = "Проигрыш"
            MesseageAlertDialog = "Упс...Не вышло :( \n Правильное число: \(numbers[0])\(numbers[1])\(numbers[2])\(numbers[3])"
            showAlert = true
        }
        if A == 4{
            TextAlertDialog = "Победа"
            MesseageAlertDialog = "Поздравляем с победой \n Правильное число: \(numbers[0])\(numbers[1])\(numbers[2])\(numbers[3])"
            showAlert = true
        }
        
        
        History[Int(Attempt)][0] = Int("\(InputNumber[0])\(InputNumber[1])\(InputNumber[2])\(InputNumber[3])") ?? 0
        History[Int(Attempt)][1] = A
        History[Int(Attempt)][2] = B
        
        Attempt += 1
        
        
        
        //var s = "\(Int(InputNumber[0]))\(Int(InputNumber[1]))\(Int(InputNumber[2]))\(Int(InputNumber[3]))"
        //Сравнения и прочее
        LastInput = [InputNumber[0],InputNumber[1],InputNumber[2],InputNumber[3]]
        LastA = A
        LastB = B
        
        A = 0
        B = 0
        for i in 0..<4{
            InputNumber[i] = -1
        }
        
    }
    

    
    //Функция ввода чисел
    func InputButtons(number: Int) {
        
        if !EnteredNumbers.contains(number) {
            EnteredNumbers.append(number)
        
        let EnterNumber = number
        if InputNumber[0] == -1{
            InputNumber[0] = EnterNumber
        }else{
            if InputNumber[1] == -1{
                InputNumber[1] = EnterNumber
            }else{
                if InputNumber[2] == -1{
                    InputNumber[2] = EnterNumber
                }else{
                    if InputNumber[3] == -1{
                        InputNumber[3] = EnterNumber
                    }
                }
            }
        }
    }
}
    //Функция почистки одного числа
    func ClearNumber() {
        if InputNumber[3] != -1{
            EnteredNumbers.removeAll(where: { $0 == InputNumber[3] })
            InputNumber[3] = -1
        }else{
            if InputNumber[2] != -1{
                EnteredNumbers.removeAll(where: { $0 == InputNumber[2] })
                InputNumber[2] = -1
            }else{
                if InputNumber[1] != -1{
                    EnteredNumbers.removeAll(where: { $0 == InputNumber[1] })
                    InputNumber[1] = -1
                }else{
                    if InputNumber[0] != -1{
                        EnteredNumbers.removeAll(where: { $0 == InputNumber[0] })
                        InputNumber[0] = -1
                        
                    }
                }
            }
        }
    }
    //Функция очистки всего поля
    func ClearAllNumber(){
        InputNumber[0] = -1
        InputNumber[1] = -1
        InputNumber[2] = -1
        InputNumber[3] = -1
        EnteredNumbers = []
        
    }
    func LastEnterReturn() -> String {
        //Проверяем если ввод завершен полностью то запоминаем последние значения
        if LastInput[0] != -1 {
            if LastInput[1] != -1  {
                if LastInput[2] != -1  {
                    if LastInput[3] != -1  {
                        return "\(LastInput[0])\(LastInput[1])\(LastInput[2])\(LastInput[3]) A:\(LastA) B:\(LastB)"
                    }else{
                        return "0000 A:0 B:0"
                    }
                }else {
                    return "0000 A:0 B:0"
                }
            }else{
                return "0000 A:0 B:0"
            }
        }else{
            return "0000 A:0 B:0"
        }
    }
    
    var body: some View {
        
        ScrollView{
        VStack {
            HStack{
                Text(InputNumber[0] == -1 ? "_" : "\(InputNumber[0])").font(.system(size: 40)).padding()
                Text(InputNumber[1] == -1 ? "_" : "\(InputNumber[1])").font(.system(size: 40)).padding()
                Text(InputNumber[2] == -1 ? "_" : "\(InputNumber[2])").font(.system(size: 40)).padding()
                Text(InputNumber[3] == -1 ? "_" : "\(InputNumber[3])").font(.system(size: 40)).padding()
                Button(action: {
                    //Обработать конец игры
                    if(InputNumber[3] != -1){
                        if(InputNumber[2] != -1){
                            if(InputNumber[1] != -1){
                                if(InputNumber[0] != -1){
                                    Game()
                                    EnteredNumbers = []
                                }
                            }
                        }
                    }
                    
                }) {
                    Image(systemName: "arrow.turn.down.left")
                        .font(.title)
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            Text("\(LastEnterReturn())")
            //Стека кнопок
            HStack{
                Button(action: {
                   InputButtons(number: 1)
                }) {
                    Text("1")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Button(action: {
                    InputButtons(number: 2)
                }) {
                    Text("2")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Button(action: {
                    InputButtons(number: 3)
                }) {
                    Text("3")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            
            HStack{
                Button(action: {
                    InputButtons(number: 4)
                }) {
                    Text("4")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Button(action: {
                    InputButtons(number: 5)
                }) {
                    Text("5")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Button(action: {
                    InputButtons(number: 6)
                }) {
                    Text("6")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            HStack{
                Button(action: {
                    InputButtons(number: 7)
                }) {
                    Text("7")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Button(action: {
                    InputButtons(number: 8)
                }) {
                    Text("8")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Button(action: {
                    InputButtons(number: 9)
                }) {
                    Text("9")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            HStack{
                Button(action: {
                    ClearNumber()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Button(action: {
                    InputButtons(number: 0)
                }) {
                    Text("0")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                Button(action: {
                    ClearAllNumber()
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
            }
            VStack{
                Text("Попытки \(Attempt)/8")
                ForEach(0..<7){index in
                    HStack{
                        Text(History[index][0] == -1 ? "" : String(History[index][0]))
                        Text(History[index][1] == -1 ? "" : "A:\(History[index][1])")
                        Text(History[index][2] == -1 ? "" : "B:\(History[index][2])")
                    }
                }
                
                
            }
            
           
        }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text(TextAlertDialog),
                message: Text(MesseageAlertDialog),
                dismissButton: .cancel(Text("ОК"), action: {back()})
        )}
    }
}
struct HoToPlayView: View {
    var body: some View {
        
        NavigationView {
            ScrollView{
            VStack{
                Text("Super mind - это игра с телефона Siemens SL45. Игра развивает логику и мышлениею.\n")
                Text("Правила игры довольно просты и логичны.\n")
                Text("Загадано 4 цифры.\n")
                Text("Загаданные цифры не повторяются.\n")
                Text("Задача их отгадывать путем ввода и получения подсказок.\n")
                Text("Когда вы вводите число, игра дает вам значения, например A:1 B:2.\n")
                Text("A - показывает количество угаданных цифр,которые стоят на своем месте. В нашем случае мы угадали одну цифру, которая стоит на своем месте.\n")
                Text("B - значит сколько цифр вы угадали, но которые стоят не на своем месте. В нашем случае мы угадали две цифры, которые верны, но не находятся на своих местах.\n")
                Text("Подумайте, какие это могут быть числа, и сделайте еще один ход, с другими числами, которые кажутся вам подходящими.\n")
                Text("Ниже под клавишами ввода есть оставшееся количество попыток и ваша история ввода чисел. У вас есть 8 попыток, чтобы отгадать число. Желаю удачи!\n\n\nPS:Спасибо V228a за копию под iOS")
                
            }.padding()
            }
            .navigationBarTitleDisplayMode(.automatic)
                    .navigationTitle("Как играть?")
                   
                
    }
    }
}
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
