//
//  ContentView.swift
//  TexfEditor+InfiniteScroll
//
//  Created by 김라영 on 2023/12/24.
//

import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    
    @Namespace var cursorPositionId
    
    @State private var reviewText: String = ""
    @State private var uiTextView: UITextView?
    @State private var cursorPosition: Int = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    Rectangle()
                        .frame(height: 500)
                    textEditorView
                }
            }
            .onChange(of: cursorPosition) { pos in
                proxy.scrollTo(cursorPositionId)
            }
        }
        .padding()
    }
    
    var textEditorView: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet.rectangle.portrait.fill")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
                Text("후기")
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 11)
                VStack(alignment: .leading) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $reviewText)
                            .introspect(.textEditor, on: .iOS(.v15, .v16, .v17), customize: { uiTextView in
                                DispatchQueue.main.async {
                                    self.uiTextView = uiTextView
                                }
                            })
                            .onChange(of: reviewText) { newValue in
                                if let textView = uiTextView {
                                    if let range = textView.selectedTextRange {
                                        let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: range.start)
                                        
                                        self.cursorPosition = cursorPosition
                                    }
                                }
                            }
                            .id(cursorPositionId)
                            .padding(.top, 10)
                            .padding(.horizontal, 10)
                            .colorMultiply(.gray)
                            .background(Color.gray)
                            .font(.callout)
                            .frame(minHeight: 246, alignment: .topLeading)
                            .cornerRadius(8)
                            .fixedSize(horizontal: false, vertical: true)
                        if reviewText == "" {
                            Text("후기를 적어주세요!")
                                .font(.callout)
                                .foregroundColor(.black.opacity(0.3))
                                .padding(.top, 17)
                                .padding(.leading, 14)
                        }
                    } //ZStack
                   
                    Color.clear
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .layoutPriority(1)
                }

        } //vstacj
        .padding(.horizontal, 16)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
