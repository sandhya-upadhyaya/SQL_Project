-- ## Who is the senior most employee based on job title?
select * from employee
order by levels desc
limit 1;

-- ## Which countries have the most invoices?
select count(*) as c, billing_country 
from invoice
group by billing_country
order by c desc;

-- ## what are top3 values of total invoice
select * from invoice
order by total desc
limit 3;

-- ## which city has the best customers?
select sum(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc;

-- ## Who is the best customer
select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1;

-- ## Write query to return the email, firstname, lastname and genre of all Rock Music Listeners. Return your list ordered alphabetically by email starting with A.
select DISTINCT email, first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
where track_id in (
 select track_id FROM track
JOIN genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
)
order by email;

-- ## Let's invite the artist who have written the most rock music in our dataset.
-- Write a query that returns the artist name and total track count of the top 10 rock bands.
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name LIKE 'ROCK'
GROUP BY artist.artist_id
order by number_of_songs desc
limit 10;

-- ## Return all the track names that have a song length longer than the average song length.
-- Return the Name and milliseconds for each track. Order by the song lenght with the longest
-- songs listed first.

select name, milliseconds
from track
where milliseconds>(
	select avg(milliseconds) as avg_track_length
	from track)
order by milliseconds desc;

-- ##Find how much amount spent by each customer on artist? Write a query to return customers
-- name, artistname and total spent

With best_selling_artist as(
	select artist.artist_id AS artist_id, artist.name as artist_name, 
	SUM(invoice_line.unit_price* invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) AS amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track  t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc;
	



