using System.Dynamic;

namespace ConsoleAppScratch;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Hello, World!");
    }
}

public interface ILogger
{
    void Log(string logMessage);
}

public class User
{
    private readonly ILogger _logger;

    public User(ILogger logger)
    {
        _logger = logger;
    }

    public void SetStatus(bool isActive)
    {
        // code to set the status of the user ...
        
        // now we log status change
        _logger.Log($"User active status is now {isActive}");
    }
    
}