//
//  ContentView.swift
//  InjectObject
//
//  Created by 梅原 奈輝 on 2023/11/01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        InjectedView()
    }
}

struct InjectedView: View {
    @ObservedObject var model = InjectedObject(\.viewModel)
    
    var body: some View {
        NavigationView {
            VStack {
                Text(model.model.text)
                
                Button("replace") {
                    model.wrappedValue = .init(model: TextModel(text: ""))
                }
                
                NavigationLink {
                    InjectedDetailView()
                } label: {
                    Text("Detail")
                }
            }
        }
    }
}

struct InjectedDetailView: View {
    @ObservedObject var model = InjectedObject(\.viewModel)
    
    var body: some View {
        TextField(
            "",
            text: .init(
                get: { model.model.text },
                set: { model.model.text = $0 }
            )
        )
        .textFieldStyle(.roundedBorder)
    }
}

struct ViewModelKey: InjectionKey {
    static var currentValue: ViewModel = {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return ViewModel(model: TextModel(text: "Preview"))
        } else {
            return ViewModel(model: TextModel(text: ""))
        }
    }()
}


extension InjectedValues {
    var viewModel: ViewModel {
        get { Self[ViewModelKey.self] }
        set { Self[ViewModelKey.self] = newValue }
    }
}

class ViewModel: ObservableObject {
    @Published var model: TextModel
    
    init(model: TextModel) {
        self.model = model
    }
}

struct TextModel {
    var text: String
}

#Preview {
    ContentView()
}
