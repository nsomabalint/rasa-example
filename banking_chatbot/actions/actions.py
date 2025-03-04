import random
from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher


class ActionCheckBalance(Action):
    def name(self) -> Text:
        return "action_check_balance"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        balance = round(random.uniform(100, 10000), 2)
        formatted_balance = f"${balance:,.2f}"
        account_type = tracker.get_slot("account_type")
        
        if account_type:
            message = f"Your {account_type} account balance is {formatted_balance}."
        else:
            message = f"Your current balance is {formatted_balance}."
        
        dispatcher.utter_message(text=message)
        
        return []
