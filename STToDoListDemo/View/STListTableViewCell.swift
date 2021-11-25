//
//  STListTableViewCell.swift
//  STToDoListDemo
//
//  Created by song on 2021/11/23.
//

import UIKit

class STListTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.st_color(hexString: "#f6f6f6")
        self.contentView.backgroundColor = self.backgroundColor
        self.selectionStyle = .none
        self.initialUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func initialUI() {
        self.contentView.addSubview(self.bgContentView)
        self.bgContentView.addSubview(self.bigCircleView)
        self.bgContentView.addSubview(self.contentLabel)
        
        self.bgContentView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(-0)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    
        self.bigCircleView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.height.equalTo(30)
            make.centerY.equalTo(self.bgContentView.snp.centerY)
        }
        
        self.contentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.bgContentView.snp.centerY)
            make.left.equalTo(self.bigCircleView.snp.right).offset(10)
            make.right.equalTo(-10)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(content: String, isDeleted: Bool) {
        self.contentLabel.text = content
//        self.contentTextField.showLine(isShow: isDeleted)
//        self.contentTextField.isUserInteractionEnabled = !isDeleted
    }
    
    func update(isSelected: Bool) {
        self.bigCircleView.showSmallCircleView(isShow: isSelected)
    }
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.backgroundColor = UIColor.clear
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    lazy var bigCircleView: STCircleButton = {
        var view = STCircleButton()
        view.layer.borderColor = UIColor.st_color(hexString: "#c3c3c3").cgColor
        view.backgroundColor = UIColor.st_color(hexString: "#ffffff")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var bgContentView: UIView = {
        var view = UIView()
        view.layer.borderColor = UIColor.st_color(hexString: "#f6f6f6").cgColor
        view.backgroundColor = UIColor.st_color(hexString: "#ffffff")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        return view
    }()
}

open class STTextField: UITextView {
    
    open var indexPath: IndexPath?
    
    public func showLine(isShow: Bool) {
        if self.online.superview == nil {
            self.addSubview(self.online)
            self.online.snp.makeConstraints { make in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(2)
                make.centerY.equalTo(self.snp.centerY).offset(2)
            }
        }
        self.online.isHidden = !isShow
        if isShow {
            self.textColor = UIColor.st_color(hexString: "#c7cdda")
        } else {
            self.textColor = UIColor.st_color(hexString: "#343c53")
        }
    }
    
    private lazy var online: UIView = {
        let onLine = UIView()
        onLine.backgroundColor = UIColor.st_color(hexString: "#c7cdda")
        return onLine
    }()
}
