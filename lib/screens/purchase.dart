import 'package:flutter/material.dart';
import 'package:stylex/widgets/backbutton.dart';
import 'package:stylex/widgets/title.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
 
  late TextEditingController search=TextEditingController();

   List<Map<String, dynamic>> orders1 = [
    {
      "title": "Women Floral Printed Kurti",
      "image":  "assets/images/categories/watch.webp",
      "date": "12 Dec 2025",
      "status": "Delivered",
      "statusColor": Colors.green,
    },
    {
      "title": "Men Casual Sneakers",
      "image": "assets/images/categories/wallet.webp",
      "date": "10 Dec 2025",
       "status": "Out for delivery",
      "statusColor": Colors.orange,
    },
    {
      "title": "Kids Hoodie",
      "image": "assets/images/categories/perfume.webp",
      "status": "Cancelled",
      "date": "05 Dec 2025",
      "statusColor": Colors.red,
    },
  ];

 

  @override
  Widget build(BuildContext context) {
   List<Map<String, dynamic>> orders;
    if(search.text.isNotEmpty){
      orders=orders1.where((e){
   return e['title'].toLowerCase().contains( search.text.toLowerCase());
   
  }).toList();
    }
    else{
      orders=orders1;
    }
   
  

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: backArrow(context),
        title: title('My purchases')
       
      ),

      body: Column(
        // mainAxisSize: MainAxisSize.min,

        children: [
         
          Row(
            children: [
               Spacer(),
              Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  )
                ),
              
              
              
                child:
                 TextField(
                  controller: search,
                  onChanged: (value) {
                    setState(() {
                    
                      
                    });
                  },
                 
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search order',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: search.text.isNotEmpty?
                    IconButton(onPressed: (){
                      setState(() {
                        search.text='';
                        
                      });
                    }, icon:Icon(Icons.cancel,color: Colors.black,))
                    :null
                  
                  ),
              
                ),
              
              ),
              SizedBox(width: 20,)
            ],
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
            
                return Container(
                  margin: EdgeInsets.only(bottom: 13),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(16),
                    border: Border(
                      right: BorderSide(color: Colors.deepOrange,width: 2),
                      // top: BorderSide(color: Colors.deepOrange,width: 1),
                      
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          order["image"],
                          height: 95,
                          width: 95,
                          fit: BoxFit.cover,
                        ),
                      ),
            
                      SizedBox(width: 12),
            
                      // Title + Status + Date
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order["title"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
            
                              SizedBox(height: 6),
            
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: order["statusColor"],
                                    size: 10,
                                  ),
                                  SizedBox(width: 6),
            
                                  Expanded(
                                    child: Text(
                                      order["status"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: order["statusColor"],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
            
                              SizedBox(height: 4),
            
                              Text(
                                "Date: ${order["date"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
