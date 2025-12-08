import UIKit

class LineGraphView: UIView {

    var values: [CGFloat] = [12, 3, 13, 8, 15, 20, 7]
    var labels: [String] = ["S","M","T","W","T","F","S"]
    private let barColor = UIColor(red: 173/255, green: 248/255, blue: 69/255, alpha: 1)
    private let axisColor = UIColor.white
    private let gridColor = UIColor(white: 1, alpha: 0.3)

    private let bottomPadding: CGFloat = 30
    private let topPadding: CGFloat = 10
    private let leftPadding: CGFloat = 35   // <-- NEW

    override func draw(_ rect: CGRect) {
        guard values.count == labels.count else { return }
        let context = UIGraphicsGetCurrentContext()

        let graphHeight = rect.height - bottomPadding - topPadding
        let graphTop = topPadding
        let graphWidth = rect.width - leftPadding

        let barWidth = graphWidth / CGFloat(values.count * 2)
        let maxValue = values.max() ?? 1

        let numberOfLines = 5
        for i in 0...numberOfLines {
            let y = graphTop + (CGFloat(i) / CGFloat(numberOfLines)) * graphHeight

            let path = UIBezierPath()
            path.move(to: CGPoint(x: leftPadding, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
            gridColor.setStroke()
            path.lineWidth = 1
            path.stroke()

            let value = Int(maxValue - (maxValue * CGFloat(i) / CGFloat(numberOfLines)))
            let text = "\(value) km"

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: axisColor
            ]
            text.draw(at: CGPoint(x: 0, y: y - 10), withAttributes: attrs)
        }

        for (index, val) in values.enumerated() {
            let x = leftPadding + CGFloat(index) * barWidth * 2 + barWidth / 2
            let barHeight = (val / maxValue) * graphHeight
            let y = graphTop + graphHeight - barHeight

            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)
            barColor.setFill()
            context?.fill(barRect)

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

