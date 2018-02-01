//
//  Copyright (c) 2017 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Firebase

class TeamsterFeedPost {
  var postID = ""
  var postDate: Date!
  var thumbURL: URL!
  var fullURL: URL!
  var author: TeamsterUser!
  var text = ""
  var comments: [TeamsterFeedComment]!
  var isLiked = false
  var mine = false
  var likeCount = 0

  init(snapshot: DataSnapshot, andComments comments: [TeamsterFeedComment], andLikes likes: [String: Any]?) {
    guard let value = snapshot.value as? [String: Any] else { return }
    self.postID = snapshot.key
    if let text = value["text"] as? String {
      self.text = text
    }
    guard let timestamp = value["timestamp"] as? Double else { return }
    self.postDate = Date(timeIntervalSince1970: (timestamp / 1_000.0))
    guard let author = value["author"] as? [String: String] else { return }
    self.author = TeamsterUser(dictionary: author)
    self.thumbURL = (value["thumb_url"] as? String).flatMap(URL.init)
    self.fullURL = (value["full_url"] as? String).flatMap(URL.init)
    self.comments = comments
    if let likes = likes {
      likeCount = likes.count
      if let uid = Auth.auth().currentUser?.uid {
        isLiked = (likes.index(forKey: uid) != nil)
      }
    }
    self.mine = self.author.userID == Auth.auth().currentUser?.uid
  }
}
