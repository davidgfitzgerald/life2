//
//  ClosingDatePicker.swift
//  Life
//
//  Created by David Fitzgerald on 02/11/2025.
//

import SwiftUI


struct ClosingDatePicker<Content: View>: View {
    /**
     * Date picker that automatically closes when
     * the selected date changes.
     *
     * TODO document how this works, it's pretty hacky.
     */
    let content: (Date) -> Content
    @Binding var date: Date
    @State private var showCalendar: Bool = false
    
    init(date: Binding<Date>, @ViewBuilder content: @escaping (Date) -> Content = {currentDate in
        /**
         * Default content to display. It _looks_ like a regular
         * DatePicker, but behind the scenes it's inactive and
         * the tap behaviour has been altered.
         */
        VStack {
            DatePicker(
                "Select date",
                selection: .constant(currentDate),
                displayedComponents: .date
            )
            .labelsHidden()
            .allowsHitTesting(false)
        }
    }) {
        self._date = date
        self.content = content
    }
    
    var body: some View {
        Button(action: {
            showCalendar = true
        }, label: {
            content(date) // Display passed in (or default) content
            .contentShape(Rectangle())
            .popover(isPresented: $showCalendar) {
                DatePicker(
                    "Select date",
                    selection: $date,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .padding(.top)
                .frame(width: 365, height: 365)
                /**
                 * TODO improve rendering.
                 *
                 * The smallest device this will support is iPhone SE (3rd Gen), which has screen width 375.
                 * From https://stackoverflow.com/a/78116229
                 */
                .presentationCompactAdaptation(.popover)
                .presentationBackground(.regularMaterial)
            }
        })
        .buttonStyle(.plain)
        .onChange(of: date) {
            showCalendar = false
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    ClosingDatePicker(date: $date)
}

