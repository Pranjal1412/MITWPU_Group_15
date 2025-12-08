import UIKit

class CaloriesGraph: UIView {

    var values: [CGFloat] = [0, 200, 500, 300, 450, 150]
    var labels: [String] = ["T","W","T","F","S","S"]

    private let barColor = UIColor(red: 173/255, green: 248/255, blue: 69/255, alpha: 1)
    private let axisColor = UIColor.white
    private let gridColor = UIColor(white: 1, alpha: 0.3)

    private let bottomPadding: CGFloat = 30
    private let topPadding: CGFloat = 10
    private let leftPadding: CGFloat = 45

    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure we redraw when the view's size changes
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        // draw using min count so mismatched arrays won't stop drawing
        let count = min(values.count, labels.count)
        guard count > 0 else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let graphHeight = rect.height - bottomPadding - topPadding
        let graphTop = topPadding
        let graphWidth = rect.width - leftPadding

        let barWidth = graphWidth / CGFloat(count * 2)
        let maxValue = max(values.max() ?? 1, 1) // avoid zero

        // draw gridlines (top -> bottom)
        let numberOfLines = 5
        for i in 0...numberOfLines {
            // y: from top (0) to bottom (graphHeight)
            let y = graphTop + (CGFloat(i) / CGFloat(numberOfLines)) * graphHeight

            let path = UIBezierPath()
            path.move(to: CGPoint(x: leftPadding, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
            gridColor.setStroke()
            path.lineWidth = 1
            path.stroke()

            // value label on left (flip because i=0 is top)
            let value = Int(maxValue - (maxValue * CGFloat(i) / CGFloat(numberOfLines)))
            let text = "\(value) kcal"
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: axisColor
            ]
            // center vertically to align better
            let textSize = text.size(withAttributes: attrs)
            let textPoint = CGPoint(x: 0, y: y - textSize.height/2)
            text.draw(at: textPoint, withAttributes: attrs)
        }

        // Draw bars and x labels
        for index in 0..<count {
            let val = values[index]
            let x = leftPadding + CGFloat(index) * barWidth * 2 + barWidth / 2
            let barHeight = (val / maxValue) * graphHeight
            let y = graphTop + graphHeight - barHeight

            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)
            barColor.setFill()
            context.fill(barRect)

            // x label
            let text = labels[index]
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                .foregroundColor: axisColor
            ]
            let size = text.size(withAttributes: attrs)
            let labelX = x + (barWidth - size.width)/2
            let labelY = graphTop + graphHeight + 5
            text.draw(at: CGPoint(x: labelX, y: labelY), withAttributes: attrs)
        }
    }
}

