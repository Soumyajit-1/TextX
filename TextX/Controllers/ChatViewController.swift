
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages : [Message] = []
    var db : Firestore!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        db = Firestore.firestore()
        loadMessages()
    }
    
    func loadMessages(){
        messages = []
        db.collection("message")
            .order(by: "dateField")
            .addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.messages = []
                for document in querySnapshot!.documents {
                    if let messageBody = document.data()["body"] as? String,
                       let messageSender = document.data()["sender"] as? String {
                        let message = Message(body: messageBody, sender: messageSender)
                        self.messages.append(message)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageTxt = messageTextfield.text , let senderEmail = Auth.auth().currentUser?.email{
            db.collection("message").addDocument(data: [
                  "sender": senderEmail,
                  "body": messageTxt,
                  "dateField" : Date().timeIntervalSince1970
                ]) { err in
                  if let err = err {
                    print("Error adding document: \(err)")
                  } else {
                    print("Document added with ID")
                  }
                }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        navigationController?.popToRootViewController(animated: true)
        
    }
    
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.messageLable.text = messages[indexPath.row].body
        let currMsg = messages[indexPath.row]
        if currMsg.sender == Auth.auth().currentUser?.email{
            cell.youAvatar.isHidden = true
        }else{
            cell.meAvatar.isHidden = true
            cell.messageView.backgroundColor = UIColor(named: "BrandLightPurple")
            cell.messageLable.textColor = UIColor.black
        }
        return cell
    }
    
    
}
