//
//  Search.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/25/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI
import Combine



struct Search: View {
  
  let cars = [""]
  @State private var searchText: String = ""
  @EnvironmentObject var spark: Spark
  
  var body: some View {
    VStack {
      SearchBar(text: $searchText)
      List {
        ForEach(self.cars.filter {
          self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())

        }, id: \.self) { car in
          Text(car)
        }
      }
    }.padding(.top, -50)
  }
}

struct Search_Previews: PreviewProvider {
  static var previews: some View {
    Search()
  }
}

struct SearchBar: UIViewRepresentable {

  @Binding var text: String

  class Coordinator: NSObject, UISearchBarDelegate {

    @Binding var text: String

    init(text: Binding<String>) {
      _text = text
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      text = searchText
    }
  }

  func makeCoordinator() -> SearchBar.Coordinator {
    return Coordinator(text: $text)
  }

  func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
    let searchBar = UISearchBar(frame: .zero)
    searchBar.delegate = context.coordinator
    searchBar.searchBarStyle = .minimal
    searchBar.placeholder = "Search"
    return searchBar
  }

  func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
    uiView.text = text
  }
}

func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
  let searchBar = UISearchBar(frame: .zero)
  searchBar.delegate = context.coordinator
  searchBar.searchBarStyle = .minimal
  searchBar.autocapitalizationType = .none
  return searchBar
}
