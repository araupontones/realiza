library(zohor)

#araupontones
# client_id = "1000.V0FA571ML6VV7YFWRC4Q7OKQ32U5PZ"
# client_secret = "c551969c7d49a7a945ac2da12d1a3fe5f241b8dae6"

#Muva
client_id = "1000.70NUR07O0MQT8DK3A6XKKBTD6MFKOE"
client_secret = "3c381997fbcfed2112516e92e5d861a153d8c36e94"
redirect <-'https://www.andresarau.com/'
scope <- 'ZohoCreator.report.READ'

#get authorization code

auth_code <- generate_auth_code(client_id = client_id,
                                scope = scope,
                                redirect_url = redirect)



#generate access token an refresh token
access_token <- get_token(base_url = "https://accounts.zoho.com",
                          client_id = client_id,
                          client_secret = client_secret,
                          redirect_url = redirect,
                          code = "1000.0b83b774ae41f1289a48fa6b2444076f.ee2008245082490b6a582214ded0fac5"
                          ) 

#
access_token$token
access_token$refresh_token
token <- "1000.8bd4af192976ab49922321f6b31176e6.a1e5183621da525b960ab6eec525c36f"
refresh_token<- "1000.09a7defc533da6ff339e5379cdf39b9b.f32f6b07f38c86d033ca791c7c8e12e0"






