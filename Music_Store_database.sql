--WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE
select * from employee
order by levels DESC
limit 1

--WHICH COUNTRIES HAVE THE MOST INVOICES
SELECT billing_country, COUNT(*) AS C
FROM invoice
GROUP BY billing_country
ORDER BY C DESC;

--WHAT ARE TOP 3 VALUES OF TOTAL INVOICE
SELECT total FROM invoice
order by total DESC
limit 3

--Which city has the best customers? 
--We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc

--Who is the best customer? 
--The customer who has spent the most money will be declared the best customer. 
--Write a query that returns the person who has spent the most money.
select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

--Write a query to return the email, first name, last name and genre of all rock music listeners.
--Return your list ordered alphabetically by email starting with A.
select distinct email, first_name, last_name
from customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
where track_id in(
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
)
order by email;

--Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the artist name and total track count of the top 10 rock bands.
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON track.album_id = album.album_id
JOIN artist ON album.artist_id = artist.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name = 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC
LIMIT 10;


--Return all the track names that have a song length longer than the average song length.
--Return the name and milliseconds for each track.
--Order by the song length with the longest songs listed first.
select name, milliseconds from track
where milliseconds > (
select avg (milliseconds) as average_length from track)
order by milliseconds DESC

--Find how much amount spent by each customer on artists? 
--Write a query to return customer name, artist name, and total spent.
WITH best_selling_artist as (
select artist.artist_id as artist_id, artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by 1
order by 3 DESC
)

select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity)as amount_spend
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc
limit 5

--The most popular music genre for each country.
--write a query that returns each country along with the top genre.
--for countries where the maximum number of purchases is shared return all genre.
