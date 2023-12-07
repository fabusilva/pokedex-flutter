package com.fabio.backend.repository;

import com.fabio.backend.model.User;
import com.fabio.backend.servise.UserServise;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.ExecutionException;

@CrossOrigin(maxAge = 3600)
@RestController
@RequestMapping("/api")
public class UserRepository {
    @Autowired
    UserServise userServise;

    @PostMapping("/user")
    public String createUser(@RequestBody User user) throws ExecutionException, InterruptedException {

        return userServise.saveUser(user);
    }

    @GetMapping("/user/{id}")
    public User getUserName(@PathVariable String id) throws ExecutionException, InterruptedException{
        return userServise.getUserID(id);
    }

    @GetMapping("/user")
    public List<User> getUser() throws ExecutionException, InterruptedException{
        return userServise.getUser();
    }

    @PutMapping("/user/update/{id}")
    public String updateUser(@PathVariable String id,@RequestBody User user) throws ExecutionException, InterruptedException {
        return userServise.updateUser(id,user);
    }

    @DeleteMapping("/user/delete/{id}")
    public String deleterUser(@PathVariable String id) throws ExecutionException, InterruptedException{
        return userServise.deleteUser(id);
    }
}
