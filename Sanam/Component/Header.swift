//
//  Header.swift
//  Sanam
//
//  Created by Hadeel on 28/06/2026.
//

import SwiftUI

struct Header: View {
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
