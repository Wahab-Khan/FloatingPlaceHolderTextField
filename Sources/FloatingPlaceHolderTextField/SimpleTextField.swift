//
//  Untitled.swift
//  FloatingPlaceHolderTextField
//
//  Created by Abdul Wahab Khan on 26/04/2025.
//

import SwiftUI

@available(macOS 17.0, *)
public struct CutomTextInputField: View {
    let text: String
    @Binding var inputText: String
    @FocusState private var isFocused: Bool

    private var borderColor: Color = .gray
    private var cornerRadius: CGFloat = 8
    private var showClear: Bool = false
    private var isRequired: Bool = false
    private var customValidation: ((String) -> String?)?

    @State private var errorMessage: String?

    public init(
        text: String,
        inputText: Binding<String>
    ) {
        self.text = text
        self._inputText = inputText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {

                Text(text)
                    .foregroundColor(.gray)
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
                    .padding(.vertical, 8)
                    .onChange(of: inputText) { _,_ in
                        validate()
                    }

                if showClear && !inputText.isEmpty {
                    clearButton
                }
            }
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(errorMessage == nil ? borderColor : .red, lineWidth: 2)
            )

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal, 8)
            }
        }
        .padding(.bottom, 4)
        .onAppear {
            validate()
        }
    }

    // MARK: - Modifiers

    func borderColor(_ color: Color) -> CutomTextInputField {
        var copy = self
        copy.borderColor = color
        return copy
    }

    func cornerRadius(_ radius: CGFloat) -> CutomTextInputField {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }

    func showClearButton(_ enabled: Bool) -> CutomTextInputField {
        var copy = self
        copy.showClear = enabled
        return copy
    }

    func validation(_ validator: @escaping (String) -> String?) -> CutomTextInputField {
        var copy = self
        copy.customValidation = validator
        return copy
    }

    func isRequired(_ required: Bool = true) -> CutomTextInputField {
        var copy = self
        copy.isRequired = required
        return copy
    }

    // MARK: - Clear Button

    var clearButton: some View {
        Button(action: {
            inputText = ""
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
        }
        .padding(.trailing, 4)
    }

    // MARK: - Validation

    private func validate() {
        if isRequired && inputText.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "This field is required"
        } else if let customValidator = customValidation {
            errorMessage = customValidator(inputText)
        } else {
            errorMessage = nil
        }
    }
}
