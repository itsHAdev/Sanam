//
//  SimulatorView.swift
//  Sanam
//
//  Created by Hadeel on 27/06/2026.
//

import SwiftUI

struct SimulatorView: View {
    @StateObject var vm = SimulatorViewModel()

    var body: some View {
        NavigationStack {
            ZStack{
                
                //MARK: - background
                Color.backApp
                    .ignoresSafeArea()
                    .overlay(
                        Image("backFrame")
                            .resizable()
                            .opacity(0.7)
                            .ignoresSafeArea())
                VStack(spacing: 32){
                    
                    headr(vm: vm)
                    
                    ScrollView{
                        LazyVStack(spacing: 30) {
                            ForEach(vm.filteredCompanies) { company in
                                NavigationLink {
                                    companyView(company: company)
                                } label: {
                                    companyRow(company: company)
                                }
                                .buttonStyle(.plain)
                            }
                        }//v
                    }//scroll
                }//vMain
            }//z
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    SimulatorView()
}

//MARK: - CompanyRow

struct companyRow: View{
    let company: Company
    var body: some View {
        
        VStack{
            HStack{
                
                ///1
                VStack(alignment: .center, spacing: 4){
                    Text("\(company.stock.currentPrice, specifier: "%.2f")")
                        .font(.system(size: 14,weight: .bold))
                        .foregroundStyle(.textApp)
                    +
                    Text(" سنام")
                        .font(.system(size: 9,weight: .bold))
                        .foregroundStyle(.textApp)
                    
                    Text(company.stock.changePercent >= 0
                         ? "+\(String(format: "%.2f", company.stock.changePercent))%"
                         : "\(String(format: "%.2f", company.stock.changePercent))%")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(company.stock.changePercent >= 0 ? .greenApp : .redApp)
                }//v1
                .frame(width: 70,height: 42)
                
                Spacer()
                
                ///2
                Image(systemName:
                        company.stock.trend == "up"
                      ? "arrowtriangle.up.fill"
                      : "arrowtriangle.down.fill")
                .foregroundStyle(company.stock.trend == "up" ? .green : .red)
                .font(.system(size: 20))
                .frame(width: 20, height: 20)
                
                Spacer()
                ///3
                VStack(alignment: .trailing, spacing: 4){
                    Text(company.fakeName)
                        .font(.system(size: 14,weight: .bold))
                        .foregroundStyle(.textApp)
                    
                    Text(company.sector)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                    
                }//v3
                .frame(width: 140,height: 32,alignment: .trailing)
                
                ///4
                ZStack{
                    
                    Circle()
                        .frame(width: 40,height: 40)
                        .foregroundStyle(.gray.opacity(0.2))
                    
                    Text(company.imageName)
                        .font(.system(size: 22))
                }//z
            }//h
            
            Color.grayApp.opacity(0.5)
                .frame(width: .infinity , height: 0.5)
        }//v
        .padding(.horizontal,16)
        .environment(\.layoutDirection, .leftToRight)
        
}
}

//MARK: - Header

struct headr: View{
    @ObservedObject var vm: SimulatorViewModel

    var body: some View {
        
        HStack{
            Menu {

                ForEach(vm.sectors, id: \.self) { sector in

                    Button {
                        vm.selectedSector = sector
                        vm.filterCompanies()
                    } label: {

                        HStack {

                            Spacer()

                            Text(sector)
                                .multilineTextAlignment(.trailing)

                            if vm.selectedSector == sector {
                                Image(systemName: "checkmark")
                            }
                        }//h
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                }
            } label: {

                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 44, height: 44)

                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 22))
                        .foregroundStyle(.textApp)
                }//z
            }
            .glassEffect()
            
            Spacer()
            
            Text("المحاكي")
                .font(.system(size: 34,weight: .bold))
            
        }//h
        .padding()
        
    }
}

#Preview {
    headr(vm: SimulatorViewModel())
}
