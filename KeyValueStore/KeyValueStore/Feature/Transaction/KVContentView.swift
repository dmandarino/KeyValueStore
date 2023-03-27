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
        KVContentView(presenter: KVTransactionalBuilder().build())
    }
}

struct TransactionalChanged: Identifiable {
    var id = UUID()
    var method: SelectedMethod
}

//struct ContentView: View {
struct KVContentView<T>: View where T: KVTransacionalModule {
    @State private var key = ""
    @State private var value = ""
    @State private var command = ""
    @State private var showingAlert = false
    @State private var givenResponse = ""
    @State private var transactionalMethod: TransactionalChanged?
    @State private var selectionInputStyle = SelectionInputStyle.manually
    @State private var preferredMethod = SelectedMethod.SET
    @ObservedObject var presenter: T
    
    enum SelectionInputStyle {
        case manually, freeForm
    }
    
    enum SelectionMethod {
        case set, get, delete, count
    }
    
    init(presenter: T) {
        self.presenter = presenter
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
                        Text("Set").tag(SelectedMethod.SET)
                        Text("Get").tag(SelectedMethod.GET)
                        Text("Delete").tag(SelectedMethod.DELETE)
                        Text("Count").tag(SelectedMethod.COUNT)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    if case .COUNT = preferredMethod {
                        TextField("Value", text: $value)
                    } else {
                        TextField("Key", text: $key)
                    }
                    if case .SET = preferredMethod {
                        TextField("Value", text: $value)
                    }
                case .freeForm:
                    TextField("Command", text: $command)
                }
            }
            Button("Submit", action: {
                guard case .freeForm = selectionInputStyle else {
                    presenter.execute(method: preferredMethod, key: key, value: value)
                    return
                }
                presenter.execute(freeForm: command)
            })
            Button("Reset Everything", action: {
                showingAlert = true
            }).foregroundColor(Color.red)
                .alert("Are you sure?", isPresented: $showingAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Yes", role: .destructive) {
                        presenter.clearAll()
                    }
                }
            Section(header: Text("Transaction")) {
                Button(SelectedMethod.BEGIN.rawValue) {
                    transactionalMethod = TransactionalChanged(method: .BEGIN)
                }
                Button(SelectedMethod.COMMIT.rawValue) {
                    transactionalMethod = TransactionalChanged(method: .COMMIT)
                }
                Button(SelectedMethod.ROLLBACK.rawValue) {
                    transactionalMethod = TransactionalChanged(method: .ROLLBACK)
                }
            }.alert(item: $transactionalMethod) { transaction in
                let method = transaction.method
                let title = Text(method.rawValue)
                let messate = "Do you want to proceed?"
                let alert = Alert(title: title,
                                  message: Text(messate),
                                  primaryButton: .destructive(Text("Cancel")) {
                    presenter.execute(transaction: method)
                },
                                  secondaryButton: .default(Text("Continue")))
                return alert
            }
            Section(header: Text("Stack Trace")) {
                Text(presenter.response)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
