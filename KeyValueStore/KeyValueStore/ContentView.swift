//
//  ContentView.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TransactionalChanged: Identifiable {
    var id: TransactionalMethod
}

struct ContentView: View {
    @State private var key = ""
    @State private var value = ""
    @State private var command = ""
    @State private var transactionalMethod: TransactionalChanged?
    
    @State private var selectionInputStyle = SelectionInputStyle.manually
    @State private var preferredMethod = SelectionMethod.set
    
    @State private var favoriteColor = "Red"
    var colors = ["Red", "Green", "Blue"]
    
    enum SelectionInputStyle {
        case manually, freeForm
    }
    
    enum SelectionMethod {
        case set, get, delete, count
    }
    
    var body: some View {
        Form {
            Section(header: Text("Select your command")) {
                Picker("", selection: $selectionInputStyle) {
                    Text("Methods").tag(SelectionInputStyle.manually)
                    Text("Free Form").tag(SelectionInputStyle.freeForm)
                }
                .pickerStyle(SegmentedPickerStyle())
                switch selectionInputStyle {
                case .manually:
                    Picker("", selection: $preferredMethod) {
                        Text("Set").tag(SelectionMethod.set)
                        Text("Get").tag(SelectionMethod.get)
                        Text("Delete").tag(SelectionMethod.delete)
                        Text("Count").tag(SelectionMethod.count)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if case .count = preferredMethod {
                        TextField("Value", text: $value)
                    } else {
                        TextField("Key", text: $key)
                    }
                    if case .set = preferredMethod {
                        TextField("Value", text: $value)
                    }
                case .freeForm:
                    TextField("Command", text: $command)
                }
            }
            Button("Submit", action: {
                print("Submit button tapped")
            })
            Section(header: Text("Transaction")) {
                Button("BEGIN") {
                    transactionalMethod = TransactionalChanged(id: .BEGIN)
                }
                Button("COMMIT") {
                    transactionalMethod = TransactionalChanged(id: .COMMIT)
                }
                Button("ROLLBACK") {
                    transactionalMethod = TransactionalChanged(id: .ROLLBACK)
                }
            }.alert(item: $transactionalMethod) { method in
                let title = Text(method.id.rawValue)
                let messate = "Do you want to proceed?"
                let alert = Alert(title: title,
                             primaryButton: .default(Text("Continue")) {
                    print("CONTINUAAAAAAA")
                },
                             secondaryButton: .destructive(Text("Cancel")))
                return alert
            }
        }
    }
}
