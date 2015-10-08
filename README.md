lib_sys
-------
Login credentials for super user :
superadmin@admin.com / foobar12

An admin can add and view admin from his home page. 
Delete admin option is availble on the "view admin" page.

Admin can view and add a book and delete and edit the book from the "View all book" page.

Admin can search for books to return or delete it.

To Return a book admin does the following :
* Search the book from his home page
* view the book by clicking on hyperlink
* Click the button to return the book (This button only appears if the book is checked out)
* Checkout history and book records are automatically updated

Admin deletes a book that is checked out
------------------
Admin can only delete a book once it is returned. So he'll ideally return the book(using return option on the home page) and then try to delete the book. Delete button only appears when the book is available.


======================================

Library member

A member can sign up from login page
And then login using those credentials

Member has the option view, edit his profile and change passwords
Member can search and checkout books to his account.

A user can have both the roles Admin and Member

Book return and checkout history:
---------------------------------
Once a user returns a book, the checkout history of the book and user gets updated accordingly to reflect that the book  has been returned on the said date.

Admin delete : 
------------
An admin cannot delete himself or super user. 
If a user is both admin and member, then upon deletion, only his admin previliges are removed.

Book delete :
------------
A book cannot be deleted if its checked out.

Extra credit functionality
--------------------------

* Suggest a book : Member suggests a book and admin can approve or delete the suggestion.

* Email : Member can register for alert by clicking on the "Set alert" button on the book's page
		  Email only works in development environment. Not configured for production env.
