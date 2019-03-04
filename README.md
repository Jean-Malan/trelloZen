# README

TrelloZen is structured as follows: 

Technologies: 
Ruby: ruby 2.6.0p0
Rails: Rails 5.2.2
NPM: 6.7.0

Backend: 

The API runs through the List controller and Model. This handles:

- Retriving boards, lists and cards. Which is pushed through to the Vuejs frontend. 
- Updating Trello with new cards that are created
- Updating Trello with the cards that move
- Building Webhooks that retrieve the movmenet of cards. 

Frontend

- The application is handled with Vuejs which as a 'trello' like feel. 
- All cards will be displayed underneath the list to which they belong. 
- The cards can be moved between lists and will update the Trello board
- Underneath the last card of each list there is a + button which will allow users to add a card. This card will be created in the list that the button was clicked.

Notes:
The Grok server address and Trello keys/tokens need to be stored in the credentials.yml.enc folder such as

trello_key: xxxxxx
trello_token: xxxxxx
ngrok_addres: xxxxx



