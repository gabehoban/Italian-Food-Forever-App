//
//  cardRow.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/18/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//

import SwiftUI

struct cardRow: View {
    var body: some View {
        var cards: [[Int]] = []
        _ = (1...18).publisher
        .collect(2)
        .collect()
        .sink(receiveValue: { cards = $0 })
        
        return ForEach(0..<cards.count, id: \.self) { array in
            HStack{
                ForEach(cards[list.datas]), id: .\self) { i in
                    ZStack {
                        Rectangle()
                            .frame(width: 150.0, height: 200)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .black, radius: 10, x: 7, y: 7)
                        VStack(alignment: .leading) {
                            if i.image != "" {

                                WebImage(url: URL(string: i.image), options: .highPriority, context: nil)
                                    .resizable()
                                    .frame(width: 150, height: 105)
                                    .cornerRadius(20)
                                    .padding(.bottom, 5)

                            }
                            Text((i.title)
                                .removingHTMLEntities)
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .frame(width: 135.0)
                                .lineLimit(3)
                            Spacer()

                        }
                    }
                }
            }
    }
}

struct cardRow_Previews: PreviewProvider {
    static var previews: some View {
        cardRow()
    }
}
