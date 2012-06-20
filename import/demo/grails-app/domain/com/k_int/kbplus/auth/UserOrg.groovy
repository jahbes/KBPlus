package com.k_int.kbplus.auth

import com.k_int.kbplus.Org

class UserOrg {

    Long dateRequested
    Long dateActioned
    int status  // 0=Pending, 1=Approved, 2=Rejected, 3=AutoApproved
    String role

    com.k_int.kbplus.Org org
    com.k_int.kbplus.auth.User user

    static constraints = {
      dateActioned(nullable:true)
      dateRequested(nullable:true)
    }
}
