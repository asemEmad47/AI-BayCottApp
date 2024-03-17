:-consult(data).


get_customer_id(Name, CustomerID) :-
    customer(CustomerID, Name).

is_Member(X,[X|_]).
is_Member(X,[_|Tail]) :-
    is_Member(X, Tail).

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

