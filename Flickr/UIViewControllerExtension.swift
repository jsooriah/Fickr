//
//  UIViewControllerExtension.swift
//  Flickr
//
//  Created by Joel Sooriah on 17/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import SafariServices
import MessageUI

extension UIViewController: SFSafariViewControllerDelegate {
    
    func openSafariViewController(withURL url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    func sendMail(withConfiguration configuration: MailConfiguration) {
        if MFMailComposeViewController.canSendMail() {
            let mailViewController: MFMailComposeViewController = {
                let mailViewController = MFMailComposeViewController()
                mailViewController.mailComposeDelegate = self
                mailViewController.setToRecipients(configuration.recipients)
                mailViewController.setSubject(configuration.subject)
                mailViewController.navigationBar.tintColor = .white
                return mailViewController
            }()
            
            present(mailViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Could not send mail", message: "Please reach out to us via \(configuration.recipients.first ?? "")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
