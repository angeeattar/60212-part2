import com.temboo.core.*;
import com.temboo.Library.Twitter.Search.*;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("angeeattar", "myFirstApp", "96K3SUiPKn7oUMrJ4muCbtbC0UuF7w93");
int x = 209;

JSONObject json;

void setup() {
  // Run the Tweets Choreo function
  //runTweetsChoreo();
  Table table;
  JSONObject theJSON = loadJSONObject("data/myResults.json"); 
  JSONArray statuses = theJSON.getJSONArray("statuses"); 
  int nTweets = statuses.size(); 
  table = new Table();

  table.addColumn("tweet");
  for (int i=0; i<nTweets; i++) {
    JSONObject aTweet = statuses.getJSONObject(i); 
    String theTweetText = aTweet.getString("text"); 
    println(i + "\t" + theTweetText);
    TableRow newRow = table.addRow();
    newRow.setString("tweet",theTweetText);
  }

  saveTable(table, "data/tweets.csv");
}

void runTweetsChoreo() {
  // Create the Choreo object using your Temboo session
  Tweets tweetsChoreo = new Tweets(session);
  tweetsChoreo.setResultType("recent");
  tweetsChoreo.setCount("100");

  // Set inputs
  tweetsChoreo.setQuery("\"okay babe\"");
  tweetsChoreo.setAccessToken("363270849-oWfdBLwY6vQOi3zmSRgcPn7QgB6KO60YXZ6hTnTM");
  tweetsChoreo.setConsumerKey("C6bFk1vcwAAK29j9u6Rp1OBZz");
  tweetsChoreo.setConsumerSecret("o92xbm2He5IdDIh4uUcbpXiiQg1S3quiq9Y7GSyKkI0JPKemgs");
  tweetsChoreo.setAccessTokenSecret("ZZ86sz8QgRN6BKkIZm6NEQ58KDabcq3alUuu6KIdeba7r");

  // Run the Choreo and store the results
  TweetsResultSet tweetsResults = tweetsChoreo.run();

  // Print results
  //println(tweetsResults.getLimit());
  //println(tweetsResults.getRemaining());
  //println(tweetsResults.getReset());
  //println(tweetsResults.getResponse());

  String[] result = {tweetsResults.getResponse()};
  // println(result);
  saveStrings("data/myResults.json", result);
}