//
//  ViewController.swift
//  CAEmitterLayer
//
//  Created by Toomas Vahter on 03/01/2019.
//  Copyright © 2019 Augmented Code.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var emitterView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        emitterView.layer.addSublayer({
            guard let image = UIImage(named: "Spark")?.cgImage else { fatalError("Failed loading image.") }
            let emitterLayer = CAEmitterLayer(image: image)
            emitterLayer.emitterPosition = emitterView.bounds.center
            emitterLayer.name = "Emitter"
            return emitterLayer
        }())
    }
    
    private var particleEmitter: CAEmitterLayer? {
        return emitterView.layer.sublayers?.first(where: { $0.name == "Emitter" }) as? CAEmitterLayer
    }
    
    enum Shape: Int {
        case circle, cuboid, line, point, rectangle, sphere
    }
    
    @IBAction func changeShape(_ sender: UISegmentedControl) {
        guard let particleEmitter = particleEmitter else { return }
        guard let shape = Shape(rawValue: sender.selectedSegmentIndex) else { return }
        switch shape {
        case .circle:
            particleEmitter.emitterCells?.forEach({ $0.color = UIColor.red.cgColor })
            particleEmitter.emitterSize = emitterView.bounds.size
            particleEmitter.emitterShape = .circle
        case .cuboid:
            particleEmitter.emitterCells?.forEach({ $0.color = UIColor.yellow.cgColor })
            particleEmitter.emitterSize = emitterView.bounds.size
            particleEmitter.emitterDepth = emitterView.bounds.size.width
            particleEmitter.emitterShape = .cuboid
        case .line:
            particleEmitter.emitterCells?.forEach({ $0.color = UIColor.blue.cgColor })
            particleEmitter.emitterSize = emitterView.bounds.size
            particleEmitter.emitterShape = .line
        case .point:
            particleEmitter.emitterCells?.forEach({ $0.color = UIColor.white.cgColor })
            particleEmitter.emitterShape = .point
        case .rectangle:
            particleEmitter.emitterCells?.forEach({ $0.color = UIColor.green.cgColor })
            particleEmitter.emitterSize = emitterView.bounds.size
            particleEmitter.emitterShape = .rectangle
        case .sphere:
            particleEmitter.emitterCells?.forEach({ $0.color = UIColor.magenta.cgColor })
            particleEmitter.emitterSize = emitterView.bounds.size
            particleEmitter.emitterShape = .sphere
        }
        
        particleEmitter.birthRate = Float.random(in: 0.5...2.0)
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension CAEmitterLayer {
    convenience init(image: CGImage) {
        self.init()
        let cell: CAEmitterCell = {
            let cell = CAEmitterCell()
            cell.birthRate = 40
            cell.contents = image
            cell.emissionLongitude = .pi / 2.0
            cell.emissionRange = CGFloat.pi / 4.0
            cell.lifetime = 16
            cell.scale = 0.3
            cell.scaleRange = 0.2
            cell.velocity = 80
            return cell
        }()
        emitterCells = [cell]
    }
}
