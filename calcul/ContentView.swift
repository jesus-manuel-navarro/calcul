//
//  ContentView.swift
//  calcul
//
//  Created by Jesús Navarro Antolin on 20/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentNumber: String = ""
    @State private var previousNumber: Double?
    @State private var currentOperator: Operator?
    @State private var result: Double?

    var body: some View {
        VStack {
            Text(result != nil ? "\(result!)" : currentNumber)
                .font(.largeTitle)
                .padding()
            
            HStack(spacing: 10) {
                ForEach(1...3, id: \.self) { number in
                    CalculatorButton(text: "\(number)", action: {
                        self.handleNumber("\(number)")
                    })
                }
                CalculatorButton(text: "+", action: { self.setOperator(.addition) })
            }
            .padding()
            
            HStack(spacing: 10) {
                ForEach(4...6, id: \.self) { number in
                    CalculatorButton(text: "\(number)", action: {
                        self.handleNumber("\(number)")
                    })
                }
                CalculatorButton(text: "-", action: { self.setOperator(.subtraction) })
            }
            .padding()
            
            HStack(spacing: 10) {
                ForEach(7...9, id: \.self) { number in
                    CalculatorButton(text: "\(number)", action: {
                        self.handleNumber("\(number)")
                    })
                }
                CalculatorButton(text: "×", action: { self.setOperator(.multiplication) })
            }
            .padding()
            
            HStack(spacing: 10) {
                CalculatorButton(text: "C", action: { self.clear() })
                CalculatorButton(text: "0", action: { self.handleNumber("0") })
                CalculatorButton(text: "=", action: { self.calculateResult() })
                CalculatorButton(text: "÷", action: { self.setOperator(.division) })
            }
            .padding()
        }
    }
    
    func handleNumber(_ number: String) {
        if let _ = result {
            // Si ya hay un resultado, comienza un nuevo cálculo
            currentNumber = number
            result = nil
        } else {
            currentNumber += number
        }
    }
    
    func setOperator(_ newOperator: Operator) {
        // Si hay un operador y un número previo, realiza la operación pendiente
        if let prevOperator = currentOperator, let prevNum = previousNumber, let currNum = Double(currentNumber) {
            switch prevOperator {
            case .addition:
                previousNumber = prevNum + currNum
            case .subtraction:
                previousNumber = prevNum - currNum
            case .multiplication:
                previousNumber = prevNum * currNum
            case .division:
                if currNum != 0 {
                    previousNumber = prevNum / currNum
                } else {
                    // Manejar la división por cero
                    result = nil
                    return
                }
            }
        } else {
            // Si no hay operador ni número previo, simplemente guarda el número actual
            previousNumber = Double(currentNumber)
        }
        
        // Actualiza el operador actual y limpia el número actual
        currentOperator = newOperator
        currentNumber = ""
    }
    
    func calculateResult() {
        if let prevOperator = currentOperator, let prevNum = previousNumber, let currNum = Double(currentNumber) {
            switch prevOperator {
            case .addition:
                result = prevNum + currNum
            case .subtraction:
                result = prevNum - currNum
            case .multiplication:
                result = prevNum * currNum
            case .division:
                if currNum != 0 {
                    result = prevNum / currNum
                } else {
                    // Manejar la división por cero
                    result = nil
                    return
                }
            }
        }
    }
    
    func clear() {
        currentNumber = ""
        previousNumber = nil
        currentOperator = nil
        result = nil
    }
}

struct CalculatorButton: View {
    var text: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.largeTitle)
                .frame(width: 80, height: 80)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(40)
        }
    }
}

enum Operator {
    case addition, subtraction, multiplication, division
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
