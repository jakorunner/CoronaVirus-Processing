import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


String URL = "https://coronavirus-monitor.p.rapidapi.com/coronavirus/cases_by_country.php"; 
String API_HOST = "coronavirus-monitor.p.rapidapi.com";
String API_KEY = "MY_RAPIDAPI_API_KEY";
String MY_COUNTRY = "MY_COUNTRY_NAME";

  
 JSONObject json;
 JSONArray values;
 JSONObject item; 
 
int INFECTADOS = 0;
int MUERTOS = 0;
int VIVOS = 0;


int INFECTADOS_1 = 0;
int MUERTOS_1 = 0;
int VIVOS_1 = 0;

int CONTADOR = 0;
String TIMESTAMP = "";

void setup() 
{
  size(displayWidth, displayHeight);
 
  try {

    URL url = new URL(URL);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    conn.setRequestProperty("x-rapidapi-host", API_HOST);
    conn.setRequestProperty("x-rapidapi-key", API_KEY);
    
    if (conn.getResponseCode() != 200) {
      throw new RuntimeException("Failed : HTTP error code : "
          + conn.getResponseCode());
    }

    BufferedReader br = new BufferedReader(new InputStreamReader(
      (conn.getInputStream())));

    String output;
    System.out.println("Output from Server .... \n");
    while ((output = br.readLine()) != null) {
      System.out.println("linea:" + output);
        System.out.println("-------");
           
        try {
          json = new JSONObject(output);
          System.out.println("linea Paises:" + json.getString("countries_stat"));
          values = new JSONArray(json.getString("countries_stat")); 
          TIMESTAMP = json.getString("statistic_taken_at");
        } catch (JSONException e){}
    }
   
    conn.disconnect();
    } catch (MalformedURLException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
}

int GetFont(int valor){
    if (displayWidth < 1000) {return (valor - 8);}
    return valor;
}

void draw() 
{
background(0);

try{
     for (int i = 0; i < values.length(); i++) {
           JSONObject item = values.getJSONObject(i); 
           String country_name = item.getString("country_name");
           String cases = item.getString("cases");
           String deaths = item.getString("deaths");
           String recupe = item.getString("total_recovered");
           String new_deaths = item.getString("new_deaths");
           String criticals  = item.getString("serious_critical");
           String new_cases  = item.getString("new_cases");
         
          textSize(GetFont(40));textAlign(CENTER);
          
          //IF MY COUNTRY, SET LARGE FONT
          if (country_name.toUpperCase().contains(MY_COUNTRY.toUpperCase())) {
              textSize(GetFont(75));
          }
          
          //SUMMARY TOTAL DATA
          VIVOS += parseInt(recupe);
          MUERTOS += parseInt(deaths);
          INFECTADOS += parseInt(cases);
                  
          if (CONTADOR == 0){
            VIVOS_1 += parseInt(recupe.replace(",",""));
            MUERTOS_1 += parseInt(deaths.replace(",",""));
            INFECTADOS_1 += parseInt(cases.replace(",",""));          
          }
          
          // FOR THE 13th first items, print data        
          if (i<13){
               cases = cases.replace(",",".");
               deaths = deaths.replace(",",".");
               recupe = recupe.replace(",",".");
               
               new_cases = new_cases.replace(",",".");
               new_deaths = new_deaths.replace(",",".");
               criticals = criticals.replace(",",".");

               int POSICION = i * 105 + 400;
               fill(200);    text(i,30 ,POSICION);
               fill(200);    text(country_name,displayWidth/2 - 320 ,POSICION);
               fill(255);    text( cases,displayWidth/2    - 50 ,POSICION);
               fill(255,0,0);text( deaths,displayWidth/2 + 150 ,POSICION);
               fill(0,255,0);text( recupe,displayWidth/2 + 350 ,POSICION);
               
               // IF MY_COUNTRY, ADDITIONAL DATA IS PRINTED
               if (country_name.toUpperCase().contains(MY_COUNTRY.toUpperCase())) {
                   textSize(GetFont(30));
                   fill(255);      text( "+" + new_cases,displayWidth/2  - 50 ,POSICION+30);
                   fill(255,0,0);  text( "+" + new_deaths,displayWidth/2 + 150 ,POSICION+30);
                   fill(255,150,0);text( "+" + criticals,displayWidth/2 + 350 ,POSICION+30);
                }
          }
     }       
     
      // FAKE INFINITY COUNTER (TO CHEAT PEOPLE)
      /*
      textSize(GetFont(40));
      fill(200);    text("TOTAL",displayWidth/2 - 320 ,displayHeight - 150);
      fill(255);    text( INFECTADOS,displayWidth/2    - 50 ,displayHeight - 150);
      fill(255,0,0);text( MUERTOS,displayWidth/2 + 150 ,displayHeight - 150);
      fill(0,255,0);text( VIVOS,displayWidth/2 + 350 ,displayHeight - 150);
      */

      //TOTALS
      textSize(GetFont(60)); 
      fill(200);    text("TOTAL",displayWidth/2 - 320 ,270);
      fill(255);    text( INFECTADOS_1,displayWidth/2    - 50 ,270);
      fill(255,0,0);text( MUERTOS_1,displayWidth/2 + 150 ,270);
      fill(0,255,0);text( VIVOS_1,displayWidth/2 + 350 ,270);
       
      // TITLE AND TIMESTAMP
      fill(200); textSize(GetFont(70));   text("CoronaVirus!!!!",displayWidth/2,90);
      fill(150);  textSize(GetFont(40));  text(TIMESTAMP.replace(" ","   "),displayWidth/2,displayHeight - 50);
      
          
} catch (JSONException e){
}
CONTADOR ++;          
            
  
}
