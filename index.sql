-- 1. Nom des lieux qui finissent par 'um'. 

SELECT nom_lieu
FROM lieu 
WHERE nom_lieu LIKE '%um';

-- 2. Nombre de personnages par lieu (trié par nombre de personnages décroissant).

SELECT l.nom_lieu, COUNT(p.id_personnage) AS nbPersonnage
FROM lieu l
JOIN personnage p  ON  l.id_lieu = p.id_lieu
GROUP BY l.nom_lieu
ORDER BY nbPersonnage DESC;

-- 3. Nom des personnages + spécialité + adresse et lieu d'habitation, triés par lieu puis par nom de personnage. 
SELECT p.nom_personnage, s.nom_specialite, p.adresse_personnage, l.nom_lieu
FROM personnage p 
JOIN specialite s ON p.id_specialite = s.id_specialite
JOIN lieu l ON p.id_lieu = l.id_lieu
ORDER BY l.nom_lieu, p.nom_personnage;


-- 4. Nom des spécialités avec nombre de personnages par spécialité (trié par nombre de personnages décroissant). 
SELECT s.nom_specialite, COUNT(p.id_personnage) AS nbPersonnage
FROM specialite s
LEFT JOIN personnage p ON s.id_specialite = p.id_specialite
GROUP BY s.nom_specialite
ORDER BY nbPersonnage DESC;

-- 5. Nom, date et lieu des batailles, classées de la plus récente à la plus ancienne (dates affichées au format jj/mm/aaaa).
SELECT b.nom_bataille, DATE_FORMAT(b.date_bataille,'%d/%m/%Y') AS dateBataille, l.nom_lieu
FROM bataille b
JOIN lieu l ON b.id_lieu= l.id_lieu
ORDER BY b.date_bataille DESC;

-- 6. Nom des potions + coût de réalisation de la potion (trié par coût décroissant). 
SELECT p.nom_potion, SUM(i.cout_ingredient * c.qte) AS coutRealisation
FROM potion p
LEFT JOIN composer c ON p.id_potion = c.id_potion
LEFT JOIN ingredient i ON c.id_ingredient = i.id_ingredient
GROUP BY p.nom_potion
ORDER BY coutRealisation DESC;

-- 7. Nom des ingrédients + coût + quantité de chaque ingrédient qui composent la potion 'Santé'. 
SELECT i.nom_ingredient, i.cout_ingredient, c.qte
FROM ingredient i
LEFT JOIN composer c ON i.id_ingredient = c.id_ingredient
LEFT JOIN potion p ON c.id_potion = p.id_potion
WHERE p.nom_potion = 'Santé';

-- 8. Nom du ou des personnages qui ont pris le plus de casques dans la bataille 'Bataille du village gaulois'. 

SELECT p.nom_personnage
FROM prendre_casque pc
JOIN personnage p ON pc.id_personnage = p.id_personnage
JOIN bataille b ON pc.id_bataille = b.id_bataille
WHERE b.nom_bataille ='Bataille du village gaulois'
AND pc.qte = ( SELECT MAX(pc.qte) FROM prendre_casque pc); 


-- 9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit). 

SELECT p.nom_personnage, SUM(b.dose_boire) AS quantiteBue
FROM boire b 
JOIN personnage p ON b.id_personnage = p.id_personnage
GROUP BY p.nom_personnage
ORDER BY quantiteBue DESC;

-- 10. Nom de la bataille où le nombre de casques pris a été le plus important. 




-- 11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre décroissant)

SELECT tc.nom_type_casque, 
COUNT(c.id_casque) AS nbCasques,
SUM(c.cout_casque) AS coutTotal 
FROM type_casque tc
JOIN casque c ON tc.id_type_casque = c.id_type_casque
GROUP BY  tc.nom_type_casque
ORDER BY coutTotal DESC;



-- 12. Nom des potions dont un des ingrédients est le poisson frais. 




-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois. 