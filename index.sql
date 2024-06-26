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

-- SELECT p.nom_personnage
-- FROM prendre_casque pc
-- JOIN personnage p ON pc.id_personnage = p.id_personnage
-- JOIN bataille b ON pc.id_bataille = b.id_bataille
-- WHERE b.nom_bataille ='Bataille du village gaulois'
-- AND pc.qte = ( SELECT MAX(pc.qte) FROM prendre_casque pc); 


-- SELECT p.nom_personnage, pc.qte
-- FROM prendre_casque pc
-- JOIN personnage p ON pc.id_personnage = p.id_personnage
-- JOIN bataille b ON pc.id_bataille = b.id_bataille
-- WHERE b.nom_bataille ='Bataille du village gaulois'
-- AND pc.qte = ( SELECT SUM(pc.qte) FROM prendre_casque pc 
-- WHERE pc.qte >= ALL (SELECT pc.qte FROM prendre_casque pc 
-- JOIN bataille b ON pc.id_bataille = b.id_bataille 
-- WHERE b.nom_bataille ='Bataille du village gaulois' ));

SELECT p.nom_personnage, SUM(pc.qte) AS nb_casques
FROM personnage p, bataille b, prendre_casque pc
WHERE p.id_personnage = pc.id_personnage
AND pc.id_bataille = b.id_bataille
AND b.nom_bataille = 'Bataille du village gaulois'
GROUP BY p.id_personnage
HAVING nb_casques >= ALL(
SELECT SUM(pc.qte)
            FROM prendre_casque pc, bataille b
            WHERE b.id_bataille = pc.id_bataille
            AND b.nom_bataille = 'Bataille du village gaulois'
            GROUP BY pc.id_personnage
)


-- 9. Nom des personnages et leur quantité de potion bue (en les classant du plus grand buveur au plus petit). 

SELECT p.nom_personnage, SUM(b.dose_boire) AS quantiteBue
FROM boire b 
JOIN personnage p ON b.id_personnage = p.id_personnage
GROUP BY p.nom_personnage
ORDER BY quantiteBue DESC;

-- 10. Nom de la bataille où le nombre de casques pris a été le plus important. 
SELECT b.nom_bataille, SUM( pc.qte) AS nbCasques
FROM bataille b
JOIN prendre_casque pc ON b.id_bataille = pc.id_bataille
GROUP BY b.id_bataille, b.nom_bataille
HAVING SUM(pc.qte) >= ALL(
	SELECT SUM(pc.qte)
	FROM prendre_casque pc
	GROUP BY pc.id_bataille);




-- 11. Combien existe-t-il de casques de chaque type et quel est leur coût total ? (classés par nombre décroissant)

SELECT tc.nom_type_casque, 
COUNT(c.id_casque) AS nbCasques,
SUM(c.cout_casque) AS coutTotal 
FROM type_casque tc
JOIN casque c ON tc.id_type_casque = c.id_type_casque
GROUP BY  tc.nom_type_casque
ORDER BY coutTotal DESC;



-- 12. Nom des potions dont un des ingrédients est le poisson frais. 

SELECT DISTINCT p.nom_potion
FROM composer c
JOIN potion p ON c.id_potion = p.id_potion
JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE i.nom_ingredient = 'Poisson frais';




-- 13. Nom du / des lieu(x) possédant le plus d'habitants, en dehors du village gaulois. 

SELECT l.nom_lieu, SUM(p.id_personnage) AS nbHabitants
FROM lieu l
INNER JOIN personnage p ON l.id_lieu = p.id_lieu
WHERE l.nom_lieu != 'Village gaulois'
GROUP BY l.nom_lieu
HAVING nbHabitants >= ALL (
SELECT SUM(p.id_personnage)
					FROM lieu l
					INNER JOIN personnage p ON l.id_lieu = p.id_lieu
					WHERE l.nom_lieu != 'Village gaulois'
					GROUP BY l.nom_lieu);



-- 14. Nom des personnages qui n'ont jamais bu aucune potion.

SELECT p.nom_personnage
FROM personnage p
WHERE p.id_personnage NOT IN(
				SELECT DISTINCT b.id_personnage
				FROM boire b);



-- 15. Nom du / des personnages qui n'ont pas le droit de boire de la potion 'Magique'.
SELECT p.nom_personnage
FROM personnage p
WHERE p.id_personnage NOT IN (
					SELECT DISTINCT ab.id_personnage
					FROM autoriser_boire ab
					WHERE ab.id_potion =(
					SELECT DISTINCT po.id_potion
					FROM potion po
					WHERE po.nom_potion = 'Magique'));



-- A. Ajoutez le personnage suivant : Champdeblix, agriculteur résidant à la ferme Hantassion de Rotomagus.


INSERT INTO personnage (nom_personnage, adresse_personnage, image_personnage, id_lieu, id_specialite)
VALUES ('GEOFFROY', 'ferme HANTASSION', 'indisponible.jpg',
	(SELECT id_lieu FROM lieu WHERE nom_lieu = 'Rotomagus'),
	(SELECT id_specialite FROM specialite WHERE nom_specialite = 'Agriculteur'));



-- B. Autorisez Bonemine à boire de la potion magique, elle est jalouse d'Iélosubmarine...
INSERT INTO autoriser_boire (id_potion, id_personnage)
VALUES ((SELECT id_potion FROM potion WHERE nom_potion ='Magique'), 
			(SELECT id_personnage FROM personnage WHERE nom_personnage = 'GEOFFROY'));


-- C. Supprimez les casques grecs qui n'ont jamais été pris lors d'une bataille.
DELETE FROM casque 
WHERE id_type_casque = (SELECT id_type_casque FROM type_casque WHERE nom_type_casque = 'Grec')
AND id_casque NOT IN (SELECT DISTINCT id_casque FROM prendre_casque);



-- D. Modifiez l'adresse de Zérozérosix : il a été mis en prison à Condate

UPDATE personnage 
SET adresse_personnage ='10 rue de prison', 
id_lieu = (SELECT id_lieu 
				FROM lieu
				WHERE nom_lieu ='Condate')
WHERE nom_personnage = 'Zérozérosix';


-- E. La potion 'Soupe' ne doit plus contenir de persil.

DELETE FROM composer 
WHERE id_potion =(SELECT id_potion FROM potion WHERE nom_potion = 'Soupe')
AND id_ingredient = (SELECT id_ingredient FROM ingredient WHERE nom_ingredient = 'Percil');


-- F. Obélix s'est trompé : ce sont 42 casques Weisenau, et non Ostrogoths, qu'il a pris lors de la bataille 'Attaque de la banque postale'. Corrigez son erreur !

UPDATE prendre_casque 
SET id_casque = (SELECT id_casque FROM casque WHERE nom_casque = 'Weisenau'),
					qte = 42
WHERE id_casque = (SELECT id_casque FROM casque WHERE nom_casque = 'Ostrogoths')
AND id_personnage = (SELECT id_personnage FROM personnage WHERE nom_personnage = 'Obélix')
AND id_bataille = (SELECT id_bataille FROM bataille WHERE nom_bataille = 'Attaque de la banque postale');




-- Exemple de creation de vue 
-- Create view 
-- Sert à créer une vue, une représentation des données pour une exploitation visuelle.
-- Contribue à sécuriser la base de données en cachant les structures des tables réelles.
-- Simplifie les requêtes complexes en stockant la requête dans une vue sql 
-- Améliore les performances des requêtes (résultat + rapide).



CREATE VIEW batailleVillageGaulois AS
SELECT 
	p.nom_personnage,
	SUM(pc.qte) AS nbCasque
FROM 
	personnage p, bataille b, prendre_casque pc
WHERE 
	p.id_personnage = pc.id_personnage
AND
	 pc.id_bataille = b.id_bataille
AND 
	b.nom_bataille = 'Bataille du village gaulois'
GROUP BY
	 p.id_personnage;
	




    SELECT * FROM bataillevillagegaulois;