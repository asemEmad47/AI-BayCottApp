:-consult(data).


get_customer_id(Name, CustomerID) :-
    customer(CustomerID, Name).

get_Item_Price(ItemName,ItemPrice):-
    item(ItemName,_,ItemPrice).


is_Member(X,[X|_]).
is_Member(X,[_|Tail]) :-
    is_Member(X, Tail).
%------------------------------------------
%p1

list_orders(CustomerName, Res) :-
    get_customer_id(CustomerName, CustomerID),
    list_orders(CustomerID, Res, []).

list_orders(CustomerID, Res, Visited) :-
    order(CustomerID, OrderID, Items),
    \+ is_Member(OrderID, Visited),
    list_orders(CustomerID, Rest, [OrderID|Visited]),
    !,
    Res = [order(CustomerID, OrderID, Items)|Rest].
list_orders(_, [], _).
%------------------------------------------
%p4

getNumOfItems(CustomerName, OrderID, Res) :-
    get_customer_id(CustomerName, CustomerID),
    order(CustomerID, OrderID, Items),
    array_Counter(Items, Res).

array_Counter([], 0).
array_Counter([_|Tail], Counter) :-
    array_Counter(Tail, SubCounter),
    Counter is SubCounter + 1.
%------------------------------------------
%p5

calcPriceOfOrder(CustomerName, OrderID, TotalPrice):-
    get_customer_id(CustomerName, CustomerID),
    order(CustomerID, OrderID, Items),
    getTotalPrice(Items,TotalPrice).
    
getTotalPrice([],0).

getTotalPrice([Item|Tail], TotalPrice):-
    get_Item_Price(Item, ItemPrice),
    getTotalPrice(Tail, SubTotal),
    TotalPrice is SubTotal + ItemPrice.
%------------------------------------------
%p10

calcPriceAfterReplacingBoycottItemsFromAnOrder(CustomerName, OrderID, NewList, TotalPrice) :-
    get_customer_id(CustomerName, CustomerID),
    order(CustomerID, OrderID, Items),
    get_Alternatives(Items, NewList),
    getTotalPrice(NewList, TotalPrice).

get_Alternatives([], []). % Base case: empty list, return empty list

get_Alternatives([Head|Tail], [Alt|NewList]) :-
    alternative(Head, Alt),
    !,
    get_Alternatives(Tail, NewList).

get_Alternatives([Item|Tail], [Item|NewList]) :-
    get_Alternatives(Tail, NewList).

