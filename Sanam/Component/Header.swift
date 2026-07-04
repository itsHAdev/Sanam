//
//  Header.swift
//  Sanam
//

import SwiftUI

//MARK: - Header 1 Button and Big tittle

import SwiftUI

struct Header1<Destination: View>: View {

    let title: String
    let icon: String
    let destination: Destination

    var body: some View {

        HStack {

            NavigationLink {
                destination
                    .navigationBarBackButtonHidden(true)
            } label: {
                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 44, height: 44)

                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(.textApp)
                }
            }
            .glassEffect()

            Spacer()

            Text(title)
                .font(.system(size: 34, weight: .bold))
        }
    }
}

//MARK: - Header 2 Back Button and tittle
struct Header2: View {
    let title: String
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
        HStack{
            Button{
                dismiss()
            }label: {
                ZStack{
                    Circle()
                        .frame(width: 44,height: 44)
                        .foregroundStyle(.clear)
                        .glassEffect()
                    
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 22))
                        .foregroundStyle(.textApp)
                }//z
                
            }//b
            
            Spacer()
            
            Text(title)
                .font(.system(size: 17))
                .foregroundStyle(.textApp)
            
            Spacer()
            
        }//h
    }
}
