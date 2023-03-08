/*
 * Trang Tran
 * February 9, 2023
 * Lab 2 - CS465 Discrete Math 
 */

import java.util.*; 

public class QuantifiedStatements {
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		int[] domain = new int[10];
		
		System.out.println("Enter 10 integers, each followed by a carriage return.");
		for (int i = 0; i < domain.length; i++) {
			domain[i] = scan.nextInt(); 
		}
		
		boolean flag = true; 
		
		/* 
		 * a) for all x if x < 0 then x is even
		 * 		p --> q = -p v q 
		 */
		
		for (int i = 0; i < domain.length; i++) {
			if ((domain[i] >= 0) || (domain[i]%2 == 0)){
					flag = true;
			}
			else {
				flag = false;
				break; 
			}
		}
		
		System.out.println("a) is " + flag); 
		
		
		/*
		 * b) there exists an x if x < 0 then x is even 
		 *         p --> q = -p v q 
		 */
		
		for (int i = 0; i < domain.length; i++) {
			if ((domain[i] >= 0) || (domain[i]%2 == 0)) {
				flag = true;
				break; 
			}
			else {
				flag = false; 
			}
		}
		
		System.out.println("b) is " + flag);
		
		/*
		 * c) there exists an x where x < 0 and x is even
		 *        x < 0 && x = even 
		 */
		
		for (int i = 0; i < domain.length; i++) { 
			if ((domain[i] < 0) && (domain[i]%2 == 0)){
				flag = true;
				break;
			}
			else {
				flag = false; 
			}
		}
		
		System.out.println("c) is " + flag);
		
		/*
		 * d) for all x, if x has a remainder 1 when divided by 3
		 * then x is divisible by 5
		 * 
		 *        if x%3 = 1 then x%5 = 0 -> 
		 *        x%3 = 1 --> x%5 = 0
		 *       -(x%3 = 1) v (x%5 = 0)
		 */
		
		for (int i = 0; i <domain.length; i++) {
			if ((domain[i]%3 != 1) || (domain[i]%5 == 0) ){
				flag = true;
			}
			else {
				flag = false;
				break; 
			}
		}
		
		System.out.println("d) is " + flag);

		/*
		 * e) there exists x, if x has a remainder 1 when divided by 3
		 * then x is divisible by 5
		 */
		
		for (int i = 0; i <domain.length; i++) {
			if ((domain[i]%3 != 1) || (domain[i]%5 == 0) ){
				flag = true;
				break;
			}
			else {
				flag = false;
			}
		}
		
		System.out.println("e) is " + flag);
		
	}
}
