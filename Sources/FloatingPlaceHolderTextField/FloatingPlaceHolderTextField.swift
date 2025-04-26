// The Swift Programming Language
// https://docs.swift.org/swift-book



import SwiftUI
#if canImport(UIKit)
import UIKit
let borderColor = Color(UIColor.systemGray4)
#else
@available(macOS 10.15, *)
let borderColor = Color.gray
#endif

@available(macOS 14.0, *)
struct TextInputField : View {
    let placeholder : String
    @Binding var inputText : String
    @FocusState private var isFocused: Bool
    
    
    @Environment(\.clearButtonOnTextField) var clearButtonOnTextField
    @Environment(\.textFieldBorderColor) var textFieldBorderColor
    
    init(text: String, inputText: Binding<String>) {
        self.placeholder = text
        self._inputText = inputText
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            Text(placeholder)
                .foregroundColor(.gray)
                .padding(.leading , 30)
                .offset(y: isFocused || !inputText.isEmpty ? -45 : 0)
                .scaleEffect(
                    isFocused || !inputText.isEmpty ? CGSize(width: 0.5, height: 0.5) : CGSize(
                        width: 1,
                        height: 1
                    ),
                    anchor: .leading
                )
                .animation(.easeOut, value: isFocused)
            
            TextField("", text: $inputText)
                .focused($isFocused)
                .padding([.leading] , 10)
                .padding(.trailing , isFocused ? 50 : 0)
                .padding([.top , .bottom], 5)
                .border(
                    isFocused ? textFieldBorderColor : Color(
                        borderColor
                    ),
                    width: 2.0
                )
                .cornerRadius(4.0)
                .padding()
                .overlay {
                    clearButton
                }
        }
    }
    
    
    var clearButton : some View {
        HStack {
            if !inputText.isEmpty && clearButtonOnTextField{
                Spacer()
                Button {
                    inputText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(borderColor))
                        .padding(.trailing, 22)
                }
            }else{
                EmptyView()
            }
            
        }
        
    }
}


//MARK: clear button
@available(macOS 10.15, *)
extension View {
    public func clearButtonOnTextField(_ clearButtonOnTextField: Bool) -> some View {
        environment(\.clearButtonOnTextField, clearButtonOnTextField)
    }
}


struct ClearButtonOnTextField : EnvironmentKey {
    static let defaultValue: Bool = true
}


@available(macOS 10.15, *)
extension EnvironmentValues {
    var clearButtonOnTextField: Bool {
        get {
            self[ClearButtonOnTextField.self]
        } set {
            self[ClearButtonOnTextField.self] = newValue
        }
    }
}



//MARK: borderColor for text field


@available(macOS 14.0, *)
extension View {
    public func textFieldBorderColor(_ textFieldBorderColor: Color) -> some View {
        environment(\.textFieldBorderColor, textFieldBorderColor)
    }
}

@available(macOS 14.0, *)
struct TextFieldBorderColor : EnvironmentKey {
    static let defaultValue: Color = .cyan
}

@available(macOS 14.0, *)
extension EnvironmentValues {
    var textFieldBorderColor : Color {
        get {
            self[TextFieldBorderColor.self]
        } set {
            self[TextFieldBorderColor.self] = newValue
        }
    }
}
