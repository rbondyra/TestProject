import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/main/resources",
        plugin = {"json:target/cucumber.json"},
        glue = "steps",
        publish = true)
public class RunCukeTest {

}
