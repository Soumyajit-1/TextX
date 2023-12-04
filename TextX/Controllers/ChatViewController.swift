
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages = [
            Message(body: "Hiii", sender: "1@2.com"),
            Message(body: "Hlww", sender: "2@1.com"),
            Message(body: "this is long text for testing mdeeiiennxnnnnskklllatteiiiobfvvvhuu kokadnuduehdueuduehdue is it showing", sender: "1@2.com")
    ]
    
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
        db.collection("message").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let body = document.data()["body"] as? String,
                       let sender = document.data()["sender"] as? String {
                        let message = Message(body: body, sender: sender)
                        self.messages.append(message)
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageTxt = messageTextfield.text , let senderEmail = Auth.auth().currentUser?.email{
            db.collection("message").addDocument(data: [
                  "sender": senderEmail,
                  "body": messageTxt
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
        
        
        return cell
    }
    
    
}
