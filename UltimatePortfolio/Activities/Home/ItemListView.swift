//
//  ItemListView.swift
//  UltimatePortfolio
//
//  Created by Kostya Kondratenko on 08.02.2021.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    let items: FetchedResults<Item>.SubSequence
    
    init(_ title: LocalizedStringKey, for items: FetchedResults<Item>.SubSequence) {
        self.title = title
        self.items = items
    }
    
    var itemsEmpty: some View {
        EmptyView()
    }
    
    var itemsList: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding([.top, .leading])
            
            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item),
                               label: { ItemListViewRow(item: item) })
            }
        }
    }
    
    var body: some View {
        if items.isEmpty {
            itemsEmpty
        } else {
            itemsList
        }
    }
}


struct ItemListViewRow: View {
    var item: Item
    
    var body: some View {
        HStack(spacing: 20) {
            Circle()
                .stroke(Color(item.project?.projectColor ?? "Light Blue"),
                        lineWidth: 3)
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading) {
                Text(item.itemTitle)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if !item.itemDetail.isEmpty {
                    Text(item.itemDetail)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
    }
}
