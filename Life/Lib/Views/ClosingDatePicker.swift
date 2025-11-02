//
//  ClosingDatePicker.swift
//  Life
//
//  Created by David Fitzgerald on 02/11/2025.
//

import SwiftUI


struct ClosingDatePicker: View {
    /**
     * Date picker that automatically closes when
     * the selected date changes.
     */
    @Binding var date: Date
    @State private var showCalendar: Bool = false
    
    var body: some View {
        Button(action: {
            showCalendar = true
        }, label: {
            HStack {
                // This displays very similarly to the
                // default DatePicker.
                Text(date, format: .dateTime.day().month().year())
                    .foregroundColor(.primary)
            }
            .padding(10)
            .frame(height: 30)
            .background(Color(.systemGray5))
            .cornerRadius(50)
        })
        .popover(isPresented: $showCalendar) {
            DatePicker(
                "Select date",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
            .frame(width: 365, height: 365)
            /**
             * The smallest device this will support is iPhone SE (3rd Gen), which has screen width 375.
             * From https://stackoverflow.com/a/78116229
             */
            .presentationCompactAdaptation(.popover)
        }
        .onChange(of: date) { _, _ in
            showCalendar = false
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    ClosingDatePicker(date: $date)
}

