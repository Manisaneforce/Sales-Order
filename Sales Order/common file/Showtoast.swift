//
//  Showtoast.swift
//  Sales Order
//
//  Created by San eforce on 11/08/23.
//

import SwiftUI
import CoreLocation

struct Showtoast: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .transition(.move(edge: .bottom))
        .animation(.easeInOut)
    }
}

struct Toast: View {
    @State private var showToast = false
    
    var body: some View {
        VStack {
            Button("Show Toast") {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
            .padding()
            
            Spacer()
        }
        .toast(isPresented: $showToast, message: "This is a toast message!")
        .padding()
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message))
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isPresented {
                Showtoast(message: message)
            }
        }
    }
}

struct Showtoast_Previews: PreviewProvider {
    static var previews: some View {
        Toast()
    }
}

//
//Data: [{"Activity_Report_Head":{"SF":"96","Worktype_code":"0","Town_code":"","dcr_activity_date":"2023-08-16 10:58:12","Daywise_Remarks":"","UKey":"EKSf_Code654147271","orderValue":"524.24","billingAddress":"Borivali","shippingAddress":"Borivali","DataSF":"96","AppVer":"1.2"},"Activity_Doctor_Report":{"Doc_Meet_Time":"2023-08-16 10:58:12","modified_time":"2023-08-16 10:58:12","stockist_code":"3","stockist_name":"Relivet Animal Health","orderValue":"524.24","CashDiscount":0,"NetAmount":"524.24","No_Of_items":"2","Invoice_Flag":"","TransSlNo":"","doctor_code":"96","doctor_name":"Kartik Test","ordertype":"order","deliveryDate":"","category_type":"","Lat":"13.029959","Long":"80.2414085","TOT_TAX_details":[{"Tax_Type":"GST 12%","Tax_Amt":"56.17"}]},"Order_Details":[{"product_Name":"FiproRel- S Dog 0.67 ml","product_code":"D111","Product_Qty":1,"Product_RegularQty":0,"Product_Total_Qty":1,"Product_Amount":220.64,"Rate":"197.00","free":"0","dis":0,"dis_value":"0.00","Off_Pro_code":"","Off_Pro_name":"","Off_Pro_Unit":"","discount_type":"","ConversionFactor":1,"UOM_Id":"2","UOM_Nm":"Pipette","TAX_details":[{"Tax_Id":"1","Tax_Val":12,"Tax_Type":"GST 12%","Tax_Amt":"23.64"}]},{"product_Name":"FiproRel - S Dog 1.34 ml","product_code":"D112","Product_Qty":1,"Product_RegularQty":0,"Product_Total_Qty":1,"Product_Amount":303.6,"Rate":"271.07","free":"0","dis":0,"dis_value":"0.00","Off_Pro_code":"","Off_Pro_name":"","Off_Pro_Unit":"","discount_type":"","ConversionFactor":1,"UOM_Id":"2","UOM_Nm":"Pipette","TAX_details":[{"Tax_Id":"1","Tax_Val":12,"Tax_Type":"GST 12%","Tax_Amt":"32.53"}]}]}]
