//
//  CardView.swift
//  FlashZilla
//
//  Created by Ahmed Mgua on 9/24/20.
//

import SwiftUI

struct CardView: View {
	@Environment(\.accessibilityDifferentiateWithoutColor)	var differentiateWithoutColor
	@Environment(\.accessibilityEnabled)	var	accessibilityEnabled
	let card:	Card
	var removal:	(()	->	Void)?	=	nil
	
	@State	private var	isShowingAnswer	=	false
	@State 	private var offset	=	CGSize.zero
	@State	private	var	feedback	=	UINotificationFeedbackGenerator()
	
	
    var body: some View {
		ZStack	{
			RoundedRectangle(cornerRadius: 25)
				.fill(
					differentiateWithoutColor
						?	Color.white
						:	Color.white
								.opacity(1	-	Double(abs(offset.width	/	50)))
				)
				.background(
					differentiateWithoutColor
						?	nil
						:	RoundedRectangle(cornerRadius: 25,	style: .continuous)
							.fill(offset.width	>	0	?	Color.green	:	.red)
						
				)
				.shadow(radius: 10)
			
			VStack	{
				
				
				if accessibilityEnabled	{
					Text(isShowingAnswer	?	card.answer	:	card.prompt)
						.font(.largeTitle)
						.foregroundColor(.black)
				}	else	{
					Spacer()
					Text(card.prompt)
						.font(.largeTitle)
						.foregroundColor(.black)
					Spacer()
					if isShowingAnswer	{
						Text(card.answer)
							.font(.title)
							.foregroundColor(.gray)
					}
					Spacer()
				}
			}
			.padding()
			.multilineTextAlignment(.center)
		}.accessibility(addTraits: .isButton)
		.frame(width:	450,	height: 250)
		.rotationEffect(.degrees(Double(offset.width	/	5)))
		.offset(x: offset.width	*	5, y: 0)
		.opacity(2	-	Double(abs(offset.width	/	50)))
		.gesture(
			DragGesture()
				.onChanged	{	offset in
					self.offset	=	offset.translation
					self.feedback.prepare()
				}
				.onEnded	{	_	in
					if abs(self.offset.width)	>	100	{
						if self.offset.width	>	0	{
//							success vibration. removed due to monotony
						}	else	{
							self.feedback.notificationOccurred(.error)
						}
						
						self.removal?()
					}	else	{
						self.offset	=	.zero
					}
				}
		)
		.onTapGesture	{
			withAnimation	{
				self.isShowingAnswer.toggle()
			}
		}
		.animation(.spring())
	}
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
		CardView(card: Card.example)
    }
}
